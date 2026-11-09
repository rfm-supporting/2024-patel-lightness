# 2024-patel-lightness
Supporting information for:

>[Patel, K. Y., Wilcox, L. M., Maloney, L. T., Ehinger, K. A., Patel, J. Y., Wiedenmann, E., & Murray, R. F. (2024).](https://doi.org/10.3758/s13428-024-02352-0) Lightness constancy in reality, in virtual reality, and on flat-panel displays. *Behavior Research Methods, 56,* 6389–6407.


The supporting material includes the following routines, which create figures
and carry out analyses reported in the paper. Files with extension .m are
MATLAB code, and files with extension .R are R code.

1. analysis_1_thouless.m
- loads trial-by-trial data from files data/data_*.txt
- plots match reflectance against match illuminance, as in Figures 5, C1, and C2
- calculates Thouless ratios
- assembles matrix of response times
- saves results in thouless.mat, which is used by the other analysis routines below

2. analysis_2_summary.m
- loads Thouless ratios from thouless.mat
- plots Thouless ratios for individual observers by condition, as in Figure 6

3. analysis_3_levene.R
- loads Thouless ratios from thouless.mat
- reports Levene's test for homogeneity of variance of Thouless ratios across the three
  environment conditions
- reports post-hoc Levene's tests for pairs of environment conditions

4. analysis_4_bootstrap.m
- loads Thouless ratios from thouless.mat
- bootstraps standard errors and confidence intervals for mean Thouless ratios
- reports bootstrapped comparisons of mean Thouless ratios across conditions

5. analysis_5_response_time.m
- loads Thouless ratios and response times from thouless.mat
- plots response times against Thouless ratios, as in Figure 7
- reports significance test on correlation between Thouless ratios and response times

6. analysis_6_polarity_model.m
- simulates a lightness matching model where matches that have the opposite contrast
  polarity as the reference stimulus have a higher cost


The supporting material also includes trial-by-trial data files (data/data_*.txt).
In a file with a name like data_at_phys.txt, the first tag after an underscore (here, 'at')
is a participant's initials, and the second tag (here, 'phys') indicates the environment
condition, which can be physical ('phys'), VR ('vr'), or flat-panel ('flat').

The data files have the following columns.
- column 1: trial number (1-150)
- column 2: side of apparatus where reference patch was shown; 0 = left, 1 = right
- column 3: reference stimulus number; an integer 0-2 that indicates which of three illuminance-reflectance pairs was shown as the reference stimulus; see columns 4 and 5 for the illuminance and reflectance values
- column 4: white luminance at reference patch (see note below)
- column 5: reference reflectance
- column 6: match illuminance number; an integer 0-4 that indicates which of five illuminances were shown at the match patch; see column 7 for illuminance value
- column 7: white luminance at match patch (see note below)
- column 8: reflectance of match patch at start of trial; randomly chosen
- column 9: observer's reflectance match setting at match patch
- column 10: response time (seconds)

Note regarding columns 4 and 7: These two columns report the intensity of incident light at
the reference and match patches. The values reported are the luminance (in cd/m^2) that
a Lambertian surface with reflectance 1.0 would have at those locations ("white luminance").
These values can be converted to illuminance (in lux) by multiplying by pi.
