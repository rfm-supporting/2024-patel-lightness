% analysis_4_bootstrap.m  Bootstrapped comparison of mean Thouless ratios
%                         across conditions

clear
clc

% load Thouless ratios for each observer in each condition
% - run analysis_1_thouless.m to generate the data file thouless.mat
% - the variable 'thouless' is a 3 x 3 x 12 array of Thouless ratios,
%   where the rows correspond to the three environments (physical, 
%   VR, and flat-panel), the columns correspond to different reference
%   reflectance values, and the slices correspond to different observers
% - see generation of 'thouless' in analysis_1_thouless.mat for details
load thouless.mat thouless

npart = size(thouless,3);  % find number of participants
nboot = 1e6;               % set number of bootstrap samples

% bootstrap mean Thouless ratios by sampling participants with replacement
mustar = NaN(3,3,nboot);
for i = 1:nboot
    kstar = unidrnd(npart,[ 1 npart ]);
    tstar = thouless(:,:,kstar);
    mustar(:,:,i) = mean(tstar,3);
end

% compare bootstrapped means across environments
fprintf('compare mean Thouless ratios across environments\n\n');
fprintf('    condition 1 = physical, 2 = VR, 3 = flat-panel\n\n');
envmu = squeeze(mean(mustar,2));
compare_boot( envmu )

% compare bootstrapped means across reference reflectances
fprintf('\ncompare mean Thouless ratios across reference reflectances\n\n');
fprintf('    condition 1 = reference reflectance 0.18, 2 = reflectance 0.39, 3 = reflectance 0.55\n\n');
refmu = squeeze(mean(mustar,1));
compare_boot( refmu )


function compare_boot( mu )

% means of bootstrapped means
means = mean(mu,2)';
fprintf('    mean of bootstrapped means:                %.4f  %.4f  %.4f\n', means);

% standard errors
stderrs = std(mu,[],2)';
fprintf('    standard deviation of bootstrapped means:  %.4f  %.4f  %.4f\n', stderrs);

% confidence intervals
clow = quantile(mu,0.025,2)';
chigh = quantile(mu,0.975,2)';
cint95 = [ clow ; chigh ];
fprintf('    95%% confidence intervals for bootstrapped means\n');
fprintf('        ( %.4f, %.4f )\n', cint95)

% significance tests
p12 = mean( mu(1,:) > mu(2,:) );
p13 = mean( mu(1,:) > mu(3,:) );
p23 = mean( mu(2,:) > mu(3,:) );
p12 = 2*min(p12,1-p12);
p13 = 2*min(p13,1-p13);
p23 = 2*min(p23,1-p23);
fprintf('    two-tailed significance tests via bootstrapping\n');
fprintf('        comparison of conditions 1 and 2: p = %.4f\n', p12);
fprintf('        comparison of conditions 1 and 3: p = %.4f\n', p13);
fprintf('        comparison of conditions 2 and 3: p = %.4f\n', p23);

end
