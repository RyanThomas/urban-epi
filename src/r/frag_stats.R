library(tidyr)
library(stringr)
library(dplyr)
library(ggplot2)

frag_tall <- read.csv("~/projects/urban_epi/data/stats/frag_stats.txt", 
                 stringsAsFactors = F,
                 header = F, 
                 col.names = c("city", "var", "val"))

frag_wide <- spread(frag_tall, var, val)
rownames(frag_wide) <- frag_wide[, 1]


# note all patchdensity = 0

tmp <- filter(frag_tall, var != "patchdensity")

# boxplot
plot(frag_wide[, -c(1, 7)])

tmp_clust <- hclust(dist(frag_wide[, -c(1,7)]))
plot(tmp_clust)
