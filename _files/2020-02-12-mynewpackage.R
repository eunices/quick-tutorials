# http://web.mit.edu/insong/www/pdf/rpackage_instructions.pdf

library(devtools)
library(roxygen2)

my.Rpackage <- as.package('mynewpackage')
load_all(my.Rpackage)
document(my.Rpackage)