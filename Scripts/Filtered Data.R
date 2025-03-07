#clearing environment and loading libraries
rm(list = ls())
load("Processed Data/simple_raw_data.RData")
library(dplyr)

####FILTERED DATA ----

#grouping singleplayer vs. multiplayer, factoring and base = "Singleplayer"
filtered_data <- simple_raw_data |>
  select(Hours_per_week, Playstyle, Anxiety, Anxiety_Difficulty) |>
  na.omit() |>
  filter(Hours_per_week <= 2*sd(Hours_per_week)) |>
  mutate(
    Playstyle = factor(ifelse(Playstyle == "Singleplayer", "Singleplayer", "Multiplayer")),
    Anxiety_Difficulty = factor(ifelse(grepl("Very|Extremely", Anxiety_Difficulty), 1, 0))
  )
filtered_data$Playstyle <- relevel(filtered_data$Playstyle, ref = "Multiplayer")
filtered_data$Anxiety_Difficulty <- relevel(filtered_data$Anxiety_Difficulty, ref = "0")

#filtering Singleplayer only data 
filtered_data_Singleplayer_only <- filtered_data |>
  select(-Anxiety) |>
  filter(Playstyle == "Singleplayer")

#saving filtered data
save(filtered_data , file = "Processed Data/filtered_data.RData")
save(filtered_data_Singleplayer_only, file = "Processed Data/filtered_data_Singleplayer_only.RData")