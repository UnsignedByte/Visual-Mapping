function tform = generate_tform(w, responses, dists)
    DrawFormattedText(w, 'Generating splines...', 'center', 'center');
    Screen('Flip', w);

    responses = mean(responses, 3); %take mean response point
    [num_d, num_r, ~, ~] = size(responses);
    
    newx = 0:max(dists);
    
    splines = zeros(num_d,length(newx));
    
    for i = 1:num_d
        dirs = zeros(1, num_r);
        for j = 1:num_r
            dirs(j) = cart2pol(responses(i,j,1,1),responses(i,j,1,2));
        end
        if(max(dirs)-min(dirs) > pi)
            dirs = mod(dirs,2*pi);
        end
        splines(i,:) = mod(spline([0 dists], [0 dirs], newx), 2*pi); %spline with only positive radians
    end
    
    function [x,unused] = createtransform(x, unused)
        for i = 1:size(x,1)
            [dir, r] = cart2pol(x(i,1),x(i,2)); %direction of z
            if r <= 1
                dir = mod(dir, 2*pi); %positive radians
                dirs = splines(:, round(r*max(dists))+1);
                
                for di = 1:num_d
                    ndi = mod(di,num_d)+1;
                    if (dirs(di)>dirs(ndi) ...
                            && ((dirs(ndi)+2*pi>dir && dirs(di)<dir) || (dirs(ndi)>dir && dirs(di)<dir+2*pi))) ...
                            || (dirs(di) < dir && dir < dirs(ndi))
                        dirhigh = dirs(ndi);
                        dirlow = dirs(di);
                        break;
                    end
                end
                
                mdist = min(mod(dirhigh-dirlow,2*pi), mod(dirlow-dirhigh, 2*pi));
                propdist = min(mod(dir-dirlow,2*pi), mod(dirlow-dir,2*pi));
                newdir = 2*pi/num_d*(di+propdist/mdist); %get dir relative to slice
                [nx, ny] = pol2cart(newdir, r);
                x(i,:) = [nx, ny];
            end
        end
    end

    DrawFormattedText(w, 'Generating transform...', 'center', 'center');
    Screen('Flip', w);

    tform = maketform('custom', 2, 2, [], @createtransform, []);
end