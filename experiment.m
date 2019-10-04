function responses = experiment(w, rect, num_d, dists, trials, mask)
    window_w = rect(3); % defining size of screen
    window_h = rect(4);

    cx = window_w/2;
    cy = window_h/2;

    num_r = length(dists); %number of distances where dots can spawn
    dotr = 5; %radius in pixels of dot

    dotms = 10; %Number of ms to show point
    maskms = 50; %Number of ms to show gabor patch mask
    
    ord = Shuffle(repmat(1:num_r*num_d, trials));

    responses = nan(num_d,num_r,trials,2); %response x and y sorted by direction and distance

    SetMouse(cx, cy, w); %Move mouse to center
    Screen('FillRect', w, [128, 128, 128], rect);
    DrawFormattedText(w, '+', 'center', 'center');
    Screen('Flip', w);
    WaitSecs(1);
    
    maskt = Screen('MakeTexture', w, mask);
    masksize = [size(mask, 1) size(mask, 2)];

    for i = 1:length(ord)
        Screen('DrawTexture', w, maskt, [], [[cx,cy]-masksize/2 [cx,cy]+masksize/2]);
        Screen('Flip', w);
        WaitSecs(maskms/1000);
        SetMouse(cx, cy, w); %Move mouse to center
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
end