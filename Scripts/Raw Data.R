#clearing environment and loading libraries
rm(list = ls())
library(dplyr)

####RETRIEVING DATA ----

#collected data extraction
collected_data <- read.csv("Collected Data/GamingStudy_data.csv")

#printing amount of people that participated the experiment
paste("The amount of participants in experiment:", sum(as.logical(unique(collected_data$S..No.))))

####RAW DATA FILTERING ----

#renaming columns, filtering irrelevant ones and configuring variable type
raw_data <- collected_data |>
  select(S..No., GADE, Hours, whyplay, Narcissism, Gender, Age, Work, Degree, Playstyle, GAD_T, SWL_T, SPIN_T) |>
  rename(
    Subject = S..No.,
    Hours_per_week = Hours,
    Anxiety = GAD_T,
    Well_Being = SWL_T,
    Social_Anxiety = SPIN_T,
    Anxiety_Difficulty = GADE,
    Whyplay = whyplay
  ) |>
  mutate(
    Subject = as.character(Subject),
    Hours_per_week = as.numeric(Hours_per_week),
    Anxiety = as.numeric(Anxiety),
    Well_Being = as.numeric(Well_Being),
    Social_Anxiety = as.numeric(Social_Anxiety),
    Anxiety_Difficulty = as.character(Anxiety_Difficulty),
    Whyplay = as.character(Whyplay),
    Narcissism = as.numeric(Narcissism),
    Gender = as.character(Gender),
    Age = as.numeric(Age),
    Work = as.character(Work),
    Degree = as.character(Degree),
    Playstyle = as.character(Playstyle)
  )

#renaming values in "Playstyle" column
raw_data <- raw_data |>
  mutate(
    Playstyle = case_when(
      Playstyle == "Multiplayer - online - with real life friends" ~ "Friends",
      Playstyle == "Multiplayer - online - with online acquaintances or teammates" ~ "Acquaintances",
      Playstyle == "Multiplayer - online - with strangers" ~ "Strangers",
      TRUE ~ Playstyle
    )
  )

#filtering out data that is hard to process (people that answered "other")
raw_data <- raw_data |>
  filter(Whyplay %in% c("having fun", "improving", "winning", "relaxing")) |>
  filter(Playstyle %in% c("Friends", "Strangers", "Singleplayer", "Acquaintances"))

#printing amount of people remaining after "other" filtering
paste("The amount of participants in experiment:", nrow(raw_data))

#saving raw data
save(raw_data, file = "Processed Data/raw_data.RData")