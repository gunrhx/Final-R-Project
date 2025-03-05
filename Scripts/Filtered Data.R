####FILTERED DATA


####PROBABLY NOT NEDED ----
#grouping friends and acquaintances as Friendly, factoring and base = "Friendly"
filtered_data <- raw_data |>
  select(Hours_per_week, Playstyle, Anxiety, Anxiety_Difficulty) |>
  na.omit() |>
  mutate(
    Playstyle = factor(case_when(
      Playstyle %in% c("Acquaintances", "Friends") ~ "Friendly",
      Playstyle == "Strangers" ~ "Strangers"),
    ),
    Anxiety_Difficulty = factor(ifelse(grepl("Very|Extremely", Anxiety_Difficulty), 1, 0))
  ) |>
  filter(!is.na(Playstyle), !is.na(Anxiety_Difficulty))
filtered_data$Playstyle <- relevel(filtered_data$Playstyle, ref = "Strangers")
filtered_data$Anxiety_Difficulty <- relevel(filtered_data$Anxiety_Difficulty, ref = "0")

####NEEDED ----
#grouping singleplayer vs. multiplayer, factoring and base = "Singleplayer"
filtered_data <- raw_data |>
  select(Hours_per_week, Playstyle, Anxiety, Anxiety_Difficulty) |>
  na.omit() |>
  filter(Hours_per_week <= 200) |>
  mutate(
    Playstyle = factor(ifelse(Playstyle == "Singleplayer", "Singleplayer", "Multiplayer")),
    Anxiety_Difficulty = factor(ifelse(grepl("Very|Extremely", Anxiety_Difficulty), 1, 0))
  )
filtered_data$Playstyle <- relevel(filtered_data$Playstyle, ref = "Multiplayer")
filtered_data$Anxiety_Difficulty <- relevel(filtered_data$Anxiety_Difficulty, ref = "0")

#filtering Singleplayer only data 
filtered_data_Singleplayer_only <- filtered_data |>
  filter(Playstyle == "Singleplayer")

#saving filtered data
save(filtered_data , file = "Processed Data/filtered_data.RData")
save(filtered_data_Singleplayer_only, file = "Processed Data/filtered_data_Singleplayer_only.RData")
