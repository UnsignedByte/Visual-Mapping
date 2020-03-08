function f =  makebar(pID, xs, ys, xxlabel, xylabel, xtitle)
    f = figure('visible', 'off');
    hold on
        bar(xs, ys);
        %add axes labels and title
        title([xtitle " for Subject " pID]);
        xlabel(xxlabel);
        ylabel(xylabel);
    hold off
end