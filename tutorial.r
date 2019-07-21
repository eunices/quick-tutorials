# Source: https://r-posts.com/exploratory-factor-analysis-in-r/

# install.packages('psych')
# install.packages('GPArotation')

library(psych)
bfi_data = bfi; dim(bfi_data)
bfi_data = bfi_data[complete.cases(bfi_data),]; dim(bfi_data)

bfi_cor = cor(bfi_data)
factors_data = fa(r = bfi_cor, nfactors = 6)
factors_data

# Mathetmatics behind factor analysis: http://www.di.fc.ul.pt/~jpn/r/factoranalysis/factoranalysis.html