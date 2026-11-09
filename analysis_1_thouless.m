% analysis_1_thouless.m  Find the Thouless ratio for each condition in
%                        the lightness matching task (Figures 5, C1, C2);
%                        also find median response time in each condition

clear
clc
close all

% initials of subjects, names of conditions, and reference reflectances
subjects = { 'at', 'cb', 'cr', 'gs', 'kc', 'lm', 'mm', 'sa', 'sh', 'sw', 'xl', 'za' };
conditions = { 'phys', 'vr', 'flat' }; % physical, VR, and flat-panel conditions
ref_reflectances = [ 0.18, 0.39, 0.55 ];

% colors to use in plots
colors = 'rgb';

% step through subjects
for s = 1:numel(subjects)

    % step through conditions
    for c = 1:numel(conditions)

        % load trial-by-trial data for this subject and condition
        fname = sprintf('data/data_%s_%s.txt',subjects{s},conditions{c});
        data = load(fname,'-ascii');

        % create a new figure window
        figure;
        hold on

        % step through reference stimuli
        for r = 1:3

            % get data for trials that showed this reference stimulus;
            % see README.txt for more information about data file columns
            k = data(:,3) == r-1;         % find trials that showed this reference stimulus
            ref_illum = pi * data(k,4);   % reference patch illuminance
            ref_reflect = data(k,5);      % reference patch reflectance
            match_illumk = data(k,6);     % match patch illuminance number
            match_illum = pi * data(k,7); % match patch illuminance
            match_reflect = data(k,9);    % observer's reflectance match setting
            rt = data(k,10);              % response times

            % plot reference stimulus and observer's match settings
            color = colors(r);
            plot(ref_illum(1), ref_reflect(1), 'o', 'MarkerSize',15, 'LineWidth', 2, 'Color', color);
            plot(match_illum, match_reflect, 'o', 'MarkerSize', 3, 'Color', color, 'MarkerFaceColor', color);

            % find median match setting at each illuminance
            match_illum2 = NaN(1,5);
            match_reflect2 = NaN(1,5);
            for m = 1:5
                k = match_illumk == m-1;
                u = match_illum(k);
                match_illum2(m) = u(1);
                match_reflect2(m) = median(match_reflect(k));
            end

            % plot median match settings
            plot(match_illum2, match_reflect2, 'o', 'MarkerSize', 10, 'Color', color, 'MarkerFaceColor', color);

            % find sum-of-squares linear fit to median match settings (on log-log axes),
            % constrained to pass through point representing the reference stimulus
            fitfn = @( x, m ) exp( m * ( log(x) - log(ref_illum(1)) ) + log(ref_reflect(1)) );
            % - in fitfn, argument m is the slope of the fitted line
            errfn = @( m ) sum( ( fitfn(match_illum2, m) - match_reflect2 ).^2 );
            mhat = fminbnd( errfn, -1.5, 0.5 );
            
            % record Thouless ratio (equals slope plus one, as shown in Appendix A of Patel et al.)
            thouless(c,r,s) = mhat + 1;

            % plot linear fit
            x = [ 10 1500 ];
            plot(x, fitfn(x, mhat), '-', 'Color', color);

            % show Thouless ratio on plot
            h = text(1.05*ref_illum(1), ref_reflect(1), sprintf('%.2f',thouless(c,r,s)));
            h.FontSize = 18;
            h.Color = color;

            % record response times
            rtime(c,r,s,:) = rt;

        end

        % format the plot
        set(gca,'XScale','log','YScale','log','FontSize',18,'Box','on');
        xmin = 0.9 * ref_illum(1);
        xmax = 1.1 * max(match_illum);
        axis([ xmin xmax 0.1 0.8 ]);
        xlabel 'match illuminance (lux)'
        ylabel 'match reflectance'
        title(sprintf('subject %s, condition %s',upper(subjects{s}), conditions{c}));
        drawnow;

    end

end

% save results
save thouless.mat subjects conditions ref_reflectances thouless rtime
