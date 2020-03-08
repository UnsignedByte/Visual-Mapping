function analyze_user(name)
    load(fullfile('Participant_Data', name, 'responses.mat'));
    load(fullfile('Participant_Data', name, 'demographics.mat'));
    pID = demographics{3};
    resp_before = squeeze(mean(resp_before, 3));
    resp_after = squeeze(mean(resp_after, 3));
    [num_d, num_r, ~] = size(resp_after);

    error_before = zeros(num_d, num_r);
    error_after = zeros(num_d, num_r);
    %  - i/num_d*360
    for i = 1:num_d
       for j = 1:num_r
           error_before(i, j) = atan2d(resp_before(i,j,2),resp_before(i,j,1)) - i/num_d*360;
           error_after(i, j) = atan2d(resp_after(i,j,2),resp_after(i,j,1)) - i/num_d*360;
       end
    end
    error_before = arrayfun(@(x) (x-360)*(abs(x-360) < x)+x*(abs(x-360) >= x), mod(error_before, 360));
    error_after = arrayfun(@(x) (x-360)*(abs(x-360) < x)+x*(abs(x-360) >= x), mod(error_after, 360));

    %    errbiqr = iqr(error_before, 2);
    %    erraiqr = iqr(error_after, 2);
    medb = min(abs(error_before), [], 2);
    meda = min(abs(error_after), [], 2);
    %    disp(medb);
    %    disp(meda);
    %    disp(mean(medb));
    %    disp(mean(meda));
    
    alldegs = [360/num_d:360/num_d:360];
    
    color1 = [52, 235, 52]/255;
    color2 = [21, 179, 87]/255;
    
    f = figure('visible', 'off');
    hold on
        bar(alldegs, meda-medb, 'FaceColor', (color1+color2)/2);
        grid on
        %add axes labels and title
        title(["Change in Error for Subject " pID]);
        xlabel("Angle (deg)");
        ylabel("Change in Error (pixels)");
    hold off
    saveas(f, fullfile('Participant_Data', name, 'error_difference.png'));
    
    f = figure('visible', 'off');
    hold on
        bar(alldegs, medb, 1, 'FaceColor', color2);
        bar(alldegs, meda, 0.5, 'FaceColor', color1);
        grid on
        legend({'Error Before','Error After'},'Location','northwest')
        %add axes labels and title
        title(["Errors for Subject " pID]);
        xlabel("Angle (deg)");
        ylabel("Error (pixels)");
    hold off
    saveas(f, fullfile('Participant_Data', name, 'errors.png'));
end