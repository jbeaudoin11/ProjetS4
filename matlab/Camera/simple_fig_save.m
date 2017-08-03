function [] = simple_fig_save( fig, file_name )
    fig.PaperPosition = [0 0 16 9];
    fig.PaperUnits = 'inches';
    fig.PaperSize = [16 9];
    saveas(fig, file_name);
end

