int = input('Participant Initial: ', 's');
nameID = upper(int);
demographics = cell(1,2);
demographics{1} = input('Age: ', 's');
demographics{2} = input('Gender: ', 's');

current = pwd();
if ~isfolder(fullfile('Participant_Data', nameID))
    mkdir(fullfile('Participant_Data', nameID));
end

Screen('Preference', 'SkipSyncTests', 1);
rng('Shuffle'); %Changed to rng('Shuffle') -Norick
[w, rect] = Screen('OpenWindow', 0,[]); % opening the screen


Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % allowing transparency in the photos

window_w = rect(3); % defining size of screen
window_h = rect(4);

cx = window_w/2;
cy = window_h/2;

num_d = 8; %number of degrees to split circle where dots can spawn
dists = [100,200,300,400,500]; % distances where dots can spawn
num_r = length(dists); %number of distances where dots can spawn
dotr = 5; %radius in pixels of dot

showms = 10; %Number of ms to show point

trials = 1;% number of times to show each point
ord = Shuffle(repmat(1:num_r*num_d, trials));

responses = nan(num_d,num_r,trials,2); %response x and y sorted by direction and distance

SetMouse(cx, cy, w); %Move mouse to center
Screen('FillRect', w, [128, 128, 128], rect);
DrawFormattedText(w, '+', 'center', 'center');
Screen('Flip', w);
WaitSecs(1);

for i = 1:length(ord)
    SetMouse(cx, cy, w); %Move mouse to center
    r = ceil(ord(i)/num_d); %get index of distance
    d = mod(ord(i),num_d)+1; %get index of direction
    dotpos = floor(dists(r)*[cos(2*pi*d/num_d), sin(2*pi*d/num_d)]); %convert to cartesian
    Screen('FillRect', w, [128, 128, 128], rect);
    Screen('FillOval', w, [], [dotpos+[cx,cy]-dotr dotpos+[cx,cy]+dotr]);
    DrawFormattedText(w, '+', 'center', 'center');
    Screen('Flip', w);
    WaitSecs(showms/1000);
    Screen('Flip', w);
    
    while 1 %get mouse click
        [x, y, clicks] = GetMouse(w);
        if clicks(1)
            ind = find(isnan(sum(responses(d,r,:,:),4)),1); %Get first empty pair
            responses(d,r,ind,:) = [x,y];
            while 1 %wait until mouse release
                [~,~, clicks] = GetMouse(w);
                if ~clicks(1)
                    break;
                end
            end
            break;
        end
    end
end

save(fullfile('Participant_Data', nameID, 'responses.mat'), 'responses');
save(fullfile('Participant_Data', nameID, 'demographics.mat'), 'demographics');
Screen('CloseAll');