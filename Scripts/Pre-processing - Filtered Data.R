####FILTERED DATA FOR ANALYSIS

#clearing environment and loading libraries and data
rm(list = ls())
load("Processed Data/simple_raw_data.RData")
library(dplyr)
source("Scripts/Functions.R")


####FILTERED DATA (FOR LINEAR REGRESSION) ----

#grouping multiplayer categories (Acquaintances, Friends, Strangers)
#removing na values and extreme observations
filtered_data <- simple_raw_data |>
  select(Hours_per_week, Playstyle, Anxiety, Anxiety_Debilitation) |>
  na.omit() |>
  filter(Hours_per_week <= 2*sd(Hours_per_week)) |>
  ##factoring Playstyle (base = Multiplayer) and Anxiety_Debilitation (0 = low anxiety)
  mutate(
    Playstyle = factor(ifelse(Playstyle == "Singleplayer", "Singleplayer", "Multiplayer")),
    ###those who answered Very or Extremely Difficult were factored as 1, the rest 0
    Anxiety_Debilitation = factor(ifelse(grepl("Very|Extremely", Anxiety_Debilitation), 1, 0))
  )
filtered_data$Playstyle <- relevel(filtered_data$Playstyle, ref = "Multiplayer")
filtered_data$Anxiety_Debilitation <- relevel(filtered_data$Anxiety_Debilitation, ref = "0")

#descriptive data of filtered data
descriptive_filtered_data <- descriptive_statistics(filtered_data)
descriptive_filtered_data$Numeric_Summary
descriptive_filtered_data$Character_Summary

####FILTERED DATA (FOR LOGICAL REGRESSION) ----

#filtering Singleplayer only data 
filtered_data_Singleplayer_only <- filtered_data |>
  select(-Anxiety) |>
  filter(Playstyle == "Singleplayer")

#descriptive data of singleplayer filtered data
descriptive_singleplayer_filtered_data <- descriptive_statistics(filtered_data_Singleplayer_only)
descriptive_singleplayer_filtered_data$Numeric_Summary
descriptive_singleplayer_filtered_data$Character_Summary

####SAVING FILTERED AND SINGLEPLAYER DATA ----

save(filtered_data , file = "Processed Data/filtered_data.RData")
save(filtered_data_Singleplayer_only, file = "Processed Data/filtered_data_Singleplayer_only.RData")