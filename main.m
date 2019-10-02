int = input('Participant Initial: ', 's');
age = input('Age: ', 's');
gender = input('Gender: ', 's');
nameID = upper(int);

current = pwd();
if ~isfolder(fullfile('Participant_Data', nameID))
    mkdir(fullfile('Participant_Data', nameID));
end

Screen('Preference', 'SkipSyncTests', 1);
rng('Shuffle'); %Changed to rng('Shuffle') -Norick
[w, rect] = Screen('OpenWindow', 0,[]); % opening the screen

Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % allowing transparency in the photos

HideCursor();
window_w = rect(3); % defining size of screen
window_h = rect(4);

cx = window_w/2;
cy = window_h/2;

num_d = 40; %number of degrees to split circle where dots can spawn
dists = [100,200,300,400,500]; % distances where dots can spawn
num_r = length(dists); %number of distances where dots can spawn
dotr = 5; %radius in pixels of dot

showms = 10; %Number of ms to show point

trials = 1;% number of times to show each point
ord = Shuffle(floor(1:1/trials:(201-1/trials)));

for i = 1:length(ord)
    dotpos = floor(dists(floor(ord(i)/num_d)+1)*[cos(2*pi/mod(ord(i),num_d)), sin(2*pi/mod(ord(i),num_d))]);
    Screen('FillRect', w, [128, 128, 128], rect);
    Screen('FillOval', w, [], [dotpos+[cx,cy]-dotr dotpos+[cx,cy]+dotr]);
    DrawFormattedText(w, '+', 'center', 'center');
    Screen('Flip', w);
    WaitSecs(showms/1000);
    
end


