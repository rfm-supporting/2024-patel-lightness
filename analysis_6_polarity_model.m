% analysis_6_polarity_model.m Implementation of a lightness model that
%                             imposes a cost on lightness matches that
%                             have the opposite contrast polarity as the
%                             reference stimulus

clear
clc

% stimulus properties
background_ref = 0.35;                  % background reflectance
reference_ref = [ 0.18 0.39 0.55 ];     % reference patch reflectances
reference_illum = 116;                  % reference illuminance (lux)
match_illum = [ 145 181 227 283 354 ];  % match illuminances (lux)

% model parameters and simulation settings
tau = 0.8;       % Thouless ratio when contrast polarity penalty is zero
w = 1;           % weight assigned to contrast polarity penalty
sigma = 0.03;    % standard deviation of model observer's reflectance estimates
alpha = 0.05;    % determines saturation point of contrast polarity penalty function
beta = 2;        % determines shape of contrast polarity penalty function
ntrials = 1000;  % number of simulated trials per match

clf
hold on

% step through reference reflectances
for k = 1:numel(reference_ref)

    % initialize matrix of match settings
    match_ref = NaN(numel(match_illum),ntrials);

    % step through match illuminances
    for i = 1:numel(match_illum)

        % simulate many trials
        for j = 1:ntrials

            % find match reflectance, without yet taking into account the penalty term for contrast polarity
            ref2match = @(r) exp( log(r) + (tau-1) * (log(match_illum(i)) - log(reference_illum)) );  % this is equation (4) in the paper
            match_ref0 = ref2match(reference_ref(k)) + normrnd(0,sigma);

            % define the penalty for opposite contrast polarity matches
            penaltyfn = @(r) wblcdf( sign(reference_ref(k)-background_ref)*(background_ref-r), alpha, beta);

            % find the match setting that minimizes weighted sum of both error terms
            errfn = @(r) (r-match_ref0).^2 + w * penaltyfn(r);
            match_ref(i,j) = fminbnd(errfn,0,1);

        end

    end

    % find median match settings
    match_ref = median(match_ref,2);

    % find Thouless ratio via linear regression of log match reflectance vs. log match illuminance,
    % with fit line constrained to pass through data point for reference stimulus
    fitfn = @(i, m) exp( log(reference_ref(k)) + m*(log(i)-log(reference_illum)) );
    errfn = @(p) sum( (log(fitfn(match_illum(:),p)) - log(match_ref(:))).^2 );
    phat = fminbnd(errfn,-1.5,0.5);
    tau_fit(k) = phat+1;
    fprintf('reference reflectance %.2f: tau = %.2f\n',reference_ref(k), tau_fit(k));

    % plot results and linear fit
    colors = 'rgb';
    h(k) = plot(match_illum,match_ref,'o','MarkerSize',15,'Color',colors(k),'MarkerFaceColor',colors(k));
    xlim = [ 0.9*reference_illum 1.2*max(match_illum) ];
    plot(xlim,fitfn(xlim,phat),'-','Color',colors(k));
    % plot(xlim, exp(b(1)*log(xlim) + b(2)),'-','Color',colors(k));
    plot(reference_illum, reference_ref(k),'o','MarkerSize',15,'Color',colors(k),'MarkerFaceColor','w','LineWidth', 2);
    hh = text(1.05*reference_illum, 1.05*reference_ref(k), sprintf('tau=%.2f',tau_fit(k)));
    set(hh,'FontSize',15);

end

% format figure
set(gca,'XScale','log','YScale','log');
set(gca,'XLim',xlim,'YLim',[ 0.1 0.65 ]);
set(gca,'Box','on');
hold off
set(gca,'FontSize',18);
xlabel 'match illuminance (lux)'
ylabel 'match reflectance'
legend(h,sprintfc('%.2f',reference_ref),'Location','SouthWest');
