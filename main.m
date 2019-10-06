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

num_d = 8; %number of degrees to split circle where dots can spawn
dists = [100,200,300,400,500]; % distances where dots can spawn
trials = 1;% number of times to show each point

g_num = 6; %six periods in gabor patch
g_con = 1; %contrast of patch
g_dir = 0; %radians to rotate gabor patch by
mask = gen_gabor(max(dists), g_num, g_con, g_dir);

resp_before = experiment(w, rect, num_d, dists, trials, mask);

tform = generate_tform(w, resp_before, dists);
mask = imtransform(mask, tform, 'UData', [-1 1], 'VData', [-1 1], ...
'XData', [-1 1], 'YData', [-1 1]);

resp_after = experiment(w, rect, num_d, dists, trials, mask);

imwrite(mask, fullfile('Participant_Data', nameID, 'mask.png'));
save(fullfile('Participant_Data', nameID, 'responses.mat'), 'resp_before', 'resp_after');
save(fullfile('Participant_Data', nameID, 'demographics.mat'), 'demographics');
Screen('CloseAll');