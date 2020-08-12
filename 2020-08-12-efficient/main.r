# https://csgillespie.github.io/efficientR/performance.html

# install.packages(c("microbenchmark", "ggplot2movies", "profvis", "Rcpp"))

library("microbenchmark")
library("ggplot2movies")
library("profvis")
library("Rcpp")

profvis({
    data(movies, package = "ggplot2movies") # Load data
    movies = movies[movies$Comedy == 1,]
    plot(movies$year, movies$rating)
    model = loess(rating ~ year, data = movies) # loess regression line
    j = order(movies$year)
    lines(movies$year[j], model$fitted[j]) # Add line to the plot
})

# devtools::install_github("csgillespie/efficient", args = "--with-keep.source")

library("efficient")
profvis(simulate_monopoly(10000))


efficient::test_rcpp()
