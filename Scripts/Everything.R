#clearing environment and loading libraries
rm(list = ls())
library(dplyr)

####RETRIEVING DATA ----

#collected data extraction
collected_data <- read.csv("Collected Data/GamingStudy_data.csv")

#printing amount of people that participated the experiment
paste("The amount of participants in experiment:", sum(as.logical(unique(collected_data$S..No.))))


####RAW DATA FILTERING ----

#renaming columns and filtering irrelevant ones
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

#printing amount of people that after "other" filtering
paste("The amount of participants in experiment:", sum(as.logical(unique(raw_data$Subject))))

#saving raw data
save(raw_data, file = "Processed Data/raw_data.RData")

####EXPLORATIVE DATA PLOTTING ----

#loading packages and data
load("Processed Data/raw_data.RData")
library(ggplot2)
library(patchwork)

#anxiety regression by hours per week, divided by gender
anxiety_by_hours_per_gender <- ggplot(raw_data, aes(x = Hours_per_week, y = Anxiety, fill = Gender, color = Gender)) +
  geom_smooth(method = "lm") +
  xlim(0, 150) +
  labs(
    title = "Anxiety Predicted by Hours per week",
    subtitle = "Divided by gender",
    x = "Hours per week",
    y = "Anxiety"
  ) +
  theme_minimal()

#bar plot of reasons for playing by playstyle, converted to percentages for direct comparison
bars_gaming_reason_by_playstyle <- ggplot(raw_data, aes(x = Whyplay, fill = Playstyle)) +
  geom_bar(
    aes(y = after_stat(count / tapply(count, x, sum)[x])),
    position = "dodge",
    color = "black",
    linewidth = .8
  ) +
  scale_y_continuous(labels = scales::percent_format(scale = 1)) +
  labs(
    title = "Reasons to Play Divided by Playstyle",
    subtitle = "note - every reason category completes to 100%",
    y = "Percentage within category",
    x = "Reason for playing"
    ) +
  theme_minimal()

#social anxiety predicted by playstyle
social_anxiety_by_playstyle <- ggplot(raw_data , aes(x = Social_Anxiety, fill = Playstyle)) +
  stat_boxplot(position = "dodge") +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

#hours predicting anxiety by playstyle
anxiety_by_hours_per_playstle <- ggplot(raw_data, aes(x = Hours_per_week, y = Anxiety, fill = Playstyle, color = Playstyle)) +
  geom_smooth(method = "lm") +
  xlim(0,160)

#anxiety, well being and social anxiety density one by the other
anxiety_density <- ggplot(raw_data, aes(x = Anxiety)) + geom_density(fill = "skyblue", alpha = .6)
social_anxiety_density <- ggplot(raw_data, aes(x = Social_Anxiety)) + geom_density(fill = "lightgreen", alpha = .6)
well_being_density <- ggplot(raw_data, aes(x = Well_Being)) + geom_density(fill = "lightyellow", alpha = .6)
anxiety_density/social_anxiety_density/well_being_density


####FILTERED DATA ----

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


#grouping singleplayer vs. multiplayer, factoring and base = "Singleplayer"
filtered_data <- raw_data |>
  select(Hours_per_week, Playstyle, Anxiety, Anxiety_Difficulty) |>
  na.omit() |>
  filter(Hours_per_week <= 200) |>
  mutate(
    Playstyle = factor(ifelse(Playstyle == "Singleplayer", "Singleplayer", "Multiplayer")),
    Anxiety_Difficulty = factor(ifelse(grepl("Very|Extremely", Anxiety_Difficulty), 1, 0))
  )
filtered_data$Playstyle <- relevel(filtered_data$Playstyle, ref = "Singleplayer")
filtered_data$Anxiety_Difficulty <- relevel(filtered_data$Anxiety_Difficulty, ref = "0")

Singleplayer_only <- filtered_data |>
  filter(Playstyle == "Singleplayer")
Multiplayer_only <- filtered_data |>
  filter(Playstyle == "Multiplayer")

####INFERENTIAL STATISTICS ----

library(pROC)

#linear regression
linear_model <- lm(data = filtered_data, Anxiety ~ Hours_per_week * Playstyle)
summary(linear_model)


# Fit the logistic regression model
logistic_model <- glm(Anxiety_Difficulty ~ Hours_per_week, data = Singleplayer_only, family = "binomial")
summary(logistic_model)

#roc curve
roc_curve <- roc(Singleplayer_only$Anxiety_Difficulty, predict(logistic_model, type = "response"))
roc_curve$auc
plot.roc(roc_curve)



