library(pacman)
p_load(dplyr,magrittr,googlesheets,janitor, ggplot2, wesanderson)
source("https://raw.githubusercontent.com/janhove/janhove.github.io/master/RCode/sortLvls.R")

ind_raw <- gs_url("https://docs.google.com/spreadsheets/d/1FgRDGUizEoZnXi6GcjtY-HKuxHPXP78WMQx21XOIxzs/pub?gid=303989575&single=true&output=csv")
indices <- gs_read(ind_raw, ws=1)
