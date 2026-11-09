% analysis_5_response_time.m  Examine correlation between Thouless ratios
%                             and response times (Figure 7)
                              
clear
clc

% load Thouless ratios, response times, and environment condition names
load thouless.mat thouless rtime conditions

% step through environment conditions
for i = 1:3

    fprintf('condition %4s\n',conditions{i});

    % get Thouless ratios and response times for this condition
    tr = squeeze(thouless(i,:,:));
    rt = squeeze(rtime(i,:,:,:));

    % report overall median response time
    fprintf('    median rt = %.4f s\n',median(rt(:)));

    % find median response time for each subject and reference reflectance
    rt_median = median(rt,3);

    % plot Thouless ratio vs. median response time
    subplot(1,3,i);
    h = plot(rt_median',tr','o');

    % format plot
    set(h, {'MarkerFaceColor'}, get(h,'Color'));
    title(conditions{i});
    if i==1
        ylabel 'Thouless ratio'
    end
    if i==2
        xlabel 'median response time (s)'
    end
    axis square
    set(gca,'XLim',[ 0 15 ],'YLim',[ 0.5 1.25 ],'YTick',0.6:0.2:1.2);
    set(gca,'FontSize',18);

    % correlation test for significant difference from zero
    [r, p, rlo, rup] = corrcoef(rt_median(:), tr(:), 'Alpha', 0.05);
    fprintf('    correlation between Thouless ratio and median response time\n');
    fprintf('        r = %7.4f, 95%% confidence interval (%.4f, %.4f)\n', r(1,2), rlo(1,2), rup(1,2));
    fprintf('        p = %6.4f\n\n', p(1,2));

end
