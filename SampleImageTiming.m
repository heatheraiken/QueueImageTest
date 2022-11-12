%
% Matlab Gabor Experiment
%
Screen('Preference', 'SkipSyncTests', 1);   % todo: check this
clearvars; %clears all the variables in the workspace, not clear the functions and the scripts
sca; % abbreviated version of Screen('CloseAll')

AssertOpenGL;
KbName('UnifyKeyNames');

% Default settings, and unit color range:
PsychDefaultSetup(2);

%propixx setup
% are we using propixx?  set to a 1 for yes, 0 for running locally
usingPropixx = 1;

% set your screen number appropriately
screenNumber = max(Screen('Screens'));

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask','General', 'FloatingPoint32Bit');

subject = 'test';

% background gray
bg = [0.5 0.5 0.5 0.0];

% configure screen 
if (usingPropixx == 1)
    
    % Tell PTB we want to display on a DataPixx device:
    PsychImaging('AddTask', 'General', 'UseDataPixx');
    
    isConnected = Datapixx('isReady');
    if ~isConnected
        Datapixx('Open');
    end

    [w, rect]=PsychImaging('OpenWindow', screenNumber, 0);

    % propixx 1440 hz refresh rate
    Datapixx('SetPropixxDlpSequenceProgram',5);
    Datapixx('RegWrRd');
    
    % auto propixx - see https://www.vpixx.com/manuals/psychtoolbox/html/PROPixxDemo4.html
    PsychProPixx('SetupFastDisplayMode', w, 12, 0);
    stimulusBuffer = PsychProPixx('GetImageBuffer');

    Screen('FillRect', w, bg);

    % todo: need real measurements here!!  these numbers are wrong
    screenWidth =   138;     % width of screen (cm) (aspect ratio 4:3)
    distance =      267;     % distance between subject and screen (cm)
else
    [w, rect] = PsychImaging('OpenWindow', screenNumber, 0.5, []);
    
    % todo: need real measurements
    screenWidth =   30;     % width of screen (cm) (aspect ratio 4:3)
    distance = 		75;     % distance between subject and screen (cm)
    stimulusBuffer = [];    % no stimulus buffer for PC
end
ppd = pi / 180 * rect(3) * distance / screenWidth;

gaborImage = imread('gabor-image.png');

% make texture so we can draw it
% assure it only fits in one VA
ppdRound = round(ppd);
gaborImageImageTexture = Screen('MakeTexture', w, gaborImage);

% suppress echo to the command line for keypresses
try
    ListenChar(2);
    
    % Seed the random number generator. Here we use the an older way to be
    % compatible with older systems. Newer syntax would be rng('shuffle'). Look
    % at the help function of rand "help rand" for more information
    rng('shuffle');
    
    % Define colors
    black_index = [0 0 0 255];
    
    xc = rect(3)/2; % horizontal screen center
    yc = rect(4)/2; % vertical screen center
    % propixx reports the full screen, not a quarter
    if (usingPropixx == 1)
        xc = 960 / 2;
        yc = 540 / 2;
    end
           
    % get the gabor image
    gaborTextureRect = Screen('Rect', gaborImageImageTexture);

    % center on screen
    imgRect = CenterRectOnPoint(gaborTextureRect, xc, yc);

    eventEntries = 1;
    if (usingPropixx == 1) 
        eventEntries = 3;
    end

    timingLog = cell(40 * eventEntries, 3);

    theta = 0;
    startTime = GetSecs;
    for x = 1:400
        theta = theta + 1;
        theta = mod(theta, 360);

        if (usingPropixx == 0)
            logTime = GetSecs;
            Screen('DrawTexture', w, gaborImageImageTexture, [], imgRect, theta);
            timingLog((x-1)*eventEntries + 1, 1) = {'DrawTexture'};
            timingLog((x-1)*eventEntries + 1, 2) = {x};
            timingLog((x-1)*eventEntries + 1, 3) = {GetSecs - logTime};

            Screen('Flip', w);
        else
            logTime = GetSecs;
            Screen('FillRect', stimulusBuffer, bg,[0 0 960 540]);
            timingLog((x-1)*eventEntries + 1, 1) = {'FillRect'};
            timingLog((x-1)*eventEntries + 1, 2) = {x};
            timingLog((x-1)*eventEntries + 1, 3) = {GetSecs - logTime};

            logTime = GetSecs;
            Screen('DrawTexture', stimulusBuffer, gaborImageImageTexture, [], imgRect, theta);
            timingLog((x-1)*eventEntries + 2, 1) = {'DrawTexture'};
            timingLog((x-1)*eventEntries + 2, 2) = {x};                
            timingLog((x-1)*eventEntries + 2, 3) = {GetSecs - logTime};

            logTime = GetSecs;
            PsychProPixx('QueueImage', stimulusBuffer);
            timingLog((x-1)*eventEntries + 3, 1) = {'QueueImage'};
            timingLog((x-1)*eventEntries + 3, 2) = {x};
            timingLog((x-1)*eventEntries + 3, 3) = {GetSecs - logTime};
        end
    end            
   
    tim=fix(clock);    
    timingLogFile = sprintf('sample-timing-temp-log-%s-%s.csv', subject, datestr(tim,30));

    tab = cell2table(timingLog, "VariableNames", {'Event', 'Step', 'Duration'});
    writetable(tab, timingLogFile);   
    
    if (usingPropixx == 1)
        Datapixx('RegWrRd');
        Datapixx('Close');
    end
    sca;
    ListenChar(0);
catch me
    sca;
    ListenChar(0);
    rethrow(me);
end    
