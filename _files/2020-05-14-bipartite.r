############ Using igraph

# Libraries
library(igraph)
inc <- matrix(sample(0:1, 50, replace = TRUE, prob=c(2,1)), 10, 5)
g <- graph_from_incidence_matrix(inc)
plot(g, layout = layout_as_bipartite,
     vertex.color=c("green","cyan")[V(g)$type+1])


############ Using bipartite
# https://fukamilab.github.io/BIO202/09-B-networks.html

# Libraries
library(bipartite)
library(data.table)

# Option 1 - dummy data
webs <- list(Safariland, barrett1987, elberling1999, 
             memmott1999, motten1982, olesen2002aigrettes)
lapply(webs, head, n=2L) # Only display the first two rows in the dataset

# Re-name the datasets according to the sites for each plant-pollinator network
webs.names <- c("Argentina", "Canada", "Sweden", "UK", "USA", "Azores") 
names(webs) <- webs.names

# Input data
data = webs$Argentina


# Option 2 - own dataset
# Potential wrangling
filepath = "data/filename.csv"
df = fread(filepath)
data = df[, list(N=.N),by=c("bee", "flower")]


# Plotting
# Heatmap
visweb(data)

# Network
plotweb(data, text.rot=90, col.low="green", col.high="blue")
# http://sape.inf.usi.ch/quick-reference/ggplot2/colour


# https://www.researchgate.net/post/How_do_I_customize_a_plotweb_graph_in_bipartite_package


# Try
# https://cran.r-project.org/web/packages/bipartiteD3/vignettes/bipartiteD3_Intro.html