function responses = experiment(w, rect, num_d, dists, trials, mask)
    window_w = rect(3); % defining size of screen
    window_h = rect(4);

    cx = window_w/2;
    cy = window_h/2;

    num_r = length(dists); %number of distances where dots can spawn
    dotr = 10; %radius in pixels of dot

    dotms = 20; %Number of ms to show point
    maskms = 250; %Number of ms to show gabor patch mask
    waitms = 250; %Nubmer of ms to wait after click before next trial
    
    ord = Shuffle(repmat(1:num_r*num_d, [1, trials]));

    responses = nan(num_d,num_r,trials,2); %response x and y sorted by direction and distance

    SetMouse(cx, cy, w); %Move mouse to center
    Screen('FillRect', w, [128, 128, 128], rect);
    DrawFormattedText(w, '+', 'center', 'center');
    Screen('Flip', w);
    WaitSecs(1);
    
    mask = imresize(mask, [max(dists)*2,max(dists)*2]);
    
    maskt = Screen('MakeTexture', w, mask);
    SetMouse(cx, cy, w); %Move mouse to center

    for i = 1:length(ord)
        Screen('DrawTexture', w, maskt, [], [[cx,cy]-max(dists) [cx,cy]+max(dists)]);
        Screen('Flip', w);
        WaitSecs(maskms/1000);
        r = ceil(ord(i)/num_d); %get index of distance
        d = mod(ord(i),num_d)+1; %get index of direction
        dotpos = floor(dists(r)*[cos(2*pi*d/num_d), sin(2*pi*d/num_d)]); %convert to cartesian
        Screen('FillRect', w, [128, 128, 128], rect);
        Screen('FillOval', w, [], [dotpos+[cx,cy]-dotr dotpos+[cx,cy]+dotr]);
        DrawFormattedText(w, '+', 'center', 'center');
        Screen('Flip', w);
        WaitSecs(dotms/1000);
        Screen('Flip', w);

        while 1 %get mouse click
            [x, y, clicks] = GetMouse(w);
            if clicks(1)
                ind = find(isnan(sum(responses(d,r,:,:),4)),1); %Get first empty pair
                responses(d,r,ind,:) = [x-cx,y-cy];
                while 1 %wait until mouse release
                    [~,~, clicks] = GetMouse(w);
                    if ~clicks(1)
                        break;
                    end
                end
                break;
            end
        end
        SetMouse(cx, cy, w); %Move mouse to center
        WaitSecs(waitms/1000);
    end
end