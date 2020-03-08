screens = Screen('Screens');
sID = 1;

if ~isfolder('Participant_Data')
    mkdir('Participant_Data');
end
S = dir('Participant_Data');

nameID = num2str(sum([S(~ismember({S.name},{'.','..'})).isdir])+1);
demographics = cell(1,3);
demographics{1} = ['00' input('Age: ', 's')];
demographics{2} = input('Gender (M/F): ', 's');
if lower(demographics{2}) == 'm'
    demographics{2} = '01';
else
    demographics{2} = '02';
end
demographics{3} = [nameID '-' demographics{2} '-' demographics{1}(end-1:end)];

current = pwd();
mkdir(fullfile('Participant_Data', nameID));

Screen('Preference', 'SkipSyncTests', 1);
rng('Shuffle'); %Changed to rng('Shuffle') -Norick
% Screen('Resolution', sID, 2880, 1800);
[w, rect] = Screen('OpenWindow', sID,[]); % opening the screen


% disp(Screen('Resolution', 0))
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % allowing transparency in the photos

num_d = 8; %number of degrees to split circle where dots can spawn
dists = [100,200,300,400,500]; % distances where dots can spawn
trials = 3;% number of times to show each point

g_stdev = 0.3; %ratio of stdev of gabor patch to width of patch
g_num = 6; %six periods in gabor patch
g_con = 1; %contrast of patch
mask = gen_gabor(max(dists), g_num, g_stdev, g_con, 0);

resp_before = experiment(w, rect, num_d, dists, trials, mask);

tform = generate_tform(w, resp_before, dists);
mask = imtransform(mask, tform, 'UData', [-1 1], 'VData', [-1 1], ...
'XData', [-1 1], 'YData', [-1 1]);

resp_after = experiment(w, rect, num_d, dists, trials, mask);

imwrite(mask, fullfile('Participant_Data', nameID, 'mask.png'));
save(fullfile('Participant_Data', nameID, 'responses.mat'), 'resp_before', 'resp_after');
save(fullfile('Participant_Data', nameID, 'demographics.mat'), 'demographics');
Screen('CloseAll');