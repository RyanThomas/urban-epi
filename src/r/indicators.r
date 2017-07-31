library(pacman)
p_load(dplyr,magrittr,googlesheets,janitor, ggplot2, wesanderson)
source("https://raw.githubusercontent.com/janhove/janhove.github.io/master/RCode/sortLvls.R")

ind_raw <- gs_url("https://docs.google.com/spreadsheets/d/1FgRDGUizEoZnXi6GcjtY-HKuxHPXP78WMQx21XOIxzs/pub?gid=303989575&single=true&output=csv")
ind_raw <- gs_read(ind_raw, ws = 2, range=cell_rows(2:ind_raw$ws$row_extent))

ind <-  ind_raw %>%
  clean_names() %>%
  remove_empty_rows() %>%
  remove_empty_cols()  # %>%
# mutate(hire_date = excel_numeric_to_date(hire_date),
#        main_cert = use_first_valid_of(certification, certification_2)) %>%
# select(-certification, -certification_2) # drop unwanted columns
ind <- ind[!is.na(ind$indicator),]
ind <- ind[!is.na(ind$primary_issue),]
ind$unit_sc <- gsub("small","Small",ind$unit_sc,fixed=TRUE)
ind$unit_of_analysis <- factor(ind$unit_of_analysis, levels=c("Site-specific", "Neighborhood", "City limits",
                                                              "City", "Metro Region", "Multi-city",
                                                              "Regional", "State", "National"), ordered=TRUE)
ind$unit_sc <- as.factor(ind$unit_sc)
ind$primary_issue[!is.na(ind$primary_issue) & ind$primary_issue=="Cross Sectoral"] <- "Green Economy"
ind$unit_of_analysis[!is.na(ind$unit_of_analysis) & ind$unit_of_analysis=="City"] <- "City limits"
ind$unit_of_analysis[!is.na(ind$unit_of_analysis) & ind$unit_of_analysis=="State"] <- "Regional"
ind$unit_of_analysis[!is.na(ind$unit_of_analysis) & ind$unit_of_analysis=="Multi-city"] <- "Regional"
ind$target_quality[!is.na(ind$target_quality) & ind$target_quality=="No target"] <- "No Target"
ind$target_quality <- as.factor(ind$target_quality)


glimpse(ind)
ind$target_quality <- as.factor(ind$target_quality)
ind$primary_issue <- as.factor(ind$primary_issue)
ind$target_quality[ind$target_quality == "No target"] <- "No Target"

#iss_equity <- select(ind$primary_issue,ind$equity) %>%
#  crosstab(primary_issue,equity)
#iss_equity
#
#prim_iss <- select(ind$primary_issue) %>%
#  tabyl(primary_issue)

#Use the nifty function to sort the data frame by primary issue
ind$primary_issue <- sortLvlsByN.fnc(ind$primary_issue)



#################################
# Commence the plotting         #
#################################

#Use the nifty function to sort the data frame by primary issue
ind$primary_issue <- sortLvlsByN.fnc(ind$primary_issue)

# Total Issues
ind %>% filter( !is.na(primary_issue) ) %>%
  group_by(primary_issue) %>% summarize(count=n()) %>%
  ggplot( aes(x=primary_issue, y=count, na.rm=TRUE)) +
  geom_point() + coord_flip() +
  labs(list(title="Count of Indicators by Primary Issue",x="Primary Issue",
            y="Count", color="Count")) +
  scale_fill_brewer(type = "qual", palette ="Greens" , direction=-1)  +
  theme_minimal() + theme(legend.position="none", plot.title = element_text(hjust = 0.5)) 
ggsave("frequency.png", width=6.5, units="in", dpi=330)

# Target Quality
ind %>% filter( !is.na(primary_issue) ) %>%
  group_by(primary_issue, target_quality) %>% summarize(count=n()) %>%
  ggplot( aes(x=primary_issue, y=count, color=target_quality, na.rm=TRUE)) +
  geom_point() + coord_flip() +
  labs(list(title="Quality of Target by Primary Issue",x="Primary Issue",
            y="Count", color="Target Quality")) +
  scale_fill_brewer(type = "qual", palette ="Greens" , direction=-1)  +
  theme_minimal() + theme(legend.position="bottom", plot.title = element_text(hjust = 0.5)) 
ggsave("target_quality.png", width=6.5, units="in", dpi=330)


# Equity by smart
smarte <- ind %>% filter( !is.na(smart), !is.na(equity) ) %>%
  group_by(smart, equity) %>% summarize(count=n()) %>%
  ggplot( aes(x=smart, y=count,color=equity, na.rm=TRUE)) +
  geom_point() + coord_flip() +
  labs(list(title="Equity Indicators versus SMART Indicators",
    x="SMART",y="Count", color="Equity")) +  theme_minimal() +
  theme_minimal() + theme(plot.title = element_text(hjust = 0.5)) + 
ggsave("equity.png", width=6.5, units="in", dpi=330)


# Unit of analysis
ind %>% filter( !is.na(primary_issue) ) %>%
  group_by(equity, unit_of_analysis) %>% summarize(count=n()) %>%
  ggplot( aes(x=unit_of_analysis, y=count,color=equity, na.rm=TRUE)) +
  geom_point() + coord_flip() +
  labs(list(title="Equity by Unit of Analysis", title.align="center",
            x="Primary Issue", y="Count", color="Equity")) +
  theme_minimal() + theme(plot.title = element_text(hjust = 0.5))
ggsave("unit_of_analysis.png", width=6.5, units="in", dpi=330)


###########################################
# End Plots                               #
###########################################

glimpse(ind)


mutate(ind, method.type =
        ifelse(grepl("Single number as reported by WDI",methodology), 999,
        ifelse(grepl("Not specified",methodology), 999,
        ifelse(grepl("Self-reported by countries",methodology), 999,
        ifelse(grepl("Methodology of collecting data was not mentioned.",methodology), 999,
        ifelse(grepl("Overlaying to sets of data visualizations.",methodology), 999,
        ifelse(grepl("self-reported",methodology), 999, "PROCESS" ) ))))))
ind$method.type
ind$methodology

table(na.omit(ind$unit_of_analysis))
table(na.omit(ind$unit_sc))

crosstab(ind$unit_sc,ind$equity)
crosstab(ind$unit_of_analysis,ind$equity)


na.omit(ind$indicator_description[ind$primary_issue=="Transportation"])
#ggsave("cross-sector.pdf")


############################################
# Print out a couple numbers for the paper #
############################################

# How many indicators for each primary issue?
sort(table(ind$primary_issue),decreasing = T)


# This isn't working... just estimate.
#gsub(pattern=" Indicator City ",
#     replacement=" City Indicators ",
#     x= ind$index)
sort(table(ind$index), decreasing = T)

# Equity indicators
sort(table(ind$equity), decreasing = T)
66+379

crosstab(ind$unit_sc,ind$equity, show_na = FALSE, percent = "row")

table(ind$unit_of_analysis)

levels(ind$index)

ind$data_source[!is.na(ind$data_source)]

unavailable <- c("Not published", "not applicable")

govt_data <- c("Census", "epa", "EPA, boston", "MassGIS", "American Community Survey",
               "Metropolitan Area Planning Council" , "California Air Resources Board (CARB)",
               "RESI, US EPA, TRI", "U.S. Energy Information", "USGS","City of Minneapolis")

other_provider <- c("cdp","dataforcities.org")

bespoke <- c("self-reported", "survey", "interview","HFA National Progress","Hamududu&Killingtveit (2012)",
             "et al.")

length(grep(paste(govt_data,collapse="|"),
            ind$data_source, ignore.case = T,value=TRUE))

length(grep(paste(unavailable,collapse="|"),
            ind$data_source, ignore.case = T,value=TRUE))

length(grep(paste(bespoke,collapse="|"),
            ind$data_source, ignore.case = T,value=TRUE))

length(grep(paste(other_provider,collapse="|"),
            ind$data_source, ignore.case = T,value=TRUE))

