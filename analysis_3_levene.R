# analysis_3_levene.R

library(R.matlab)
library(car)

# load Thouless ratios
thouless <- readMat('thouless.mat')$thouless
thouless <- as.vector(thouless)
df <- as.data.frame(thouless)

# add environment factor
df$env <- factor(c('phys','vr','flat'))

# Levene's test across all three environments
x <- leveneTest(thouless ~ env, data=df)
print(x)

# post-hoc comparisons

# physical vs. vr
x12 <- leveneTest(thouless ~ env, data=subset(df, env != "flat"))
print(x12)

# physical vs. flat-panel
x13 <- leveneTest(thouless ~ env, data=subset(df, env != "vr"))
print(x13)

# vr vs. flat-panel
x23 <- leveneTest(thouless ~ env, data=subset(df, env != "phys"))
print(x23)
