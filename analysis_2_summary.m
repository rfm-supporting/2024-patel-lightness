% analysis_2_thouless.m  Plot Thouless ratios by condition (Figure 6)

clear
clc
clf

% load Thouless ratios, environment condition names, and reference reflectances
load thouless.mat thouless conditions ref_reflectances

% convert references reflectances to strings for axis tick labels
xticklabel = arrayfun( @(x) sprintf('%.2f',x), ref_reflectances, 'UniformOutput', false);

% step through environment conditions (physical, VR, flat-panel)
for i = 1:3

    % plot Thouless ratios for this condition
    subplot(1,3,i);
    tr = squeeze(thouless(i,:,:));
    h = plot(tr,'o-');

    % format plot
    set(h, {'MarkerFaceColor'}, get(h,'Color'));
    axis([ 0.5 3.5 0.55 1.3 ]);
    set(gca,'XTickLabel', xticklabel);
    title(conditions{i});
    if i==1
        ylabel 'Thouless ratio'
    end
    if i==2
        xlabel 'reference reflectance'
    end
    set(gca,'FontSize',18);

end
