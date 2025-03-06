####EXPLORATIVE DATA PLOTTING ----

#loading packages and data
load("Processed Data/raw_data.RData")
source("Scripts/Functions.R")
library(ggplot2)
library(patchwork)

#discriptive statistics
descriptive_stats(raw_data)

raw_data |>
  group_by(Gender) |>
  summarise(
    amount = n(),
    mean_age = mean(Age, na.rm = TRUE),
    sd_age = sd(Age, na.rm = TRUE),
    age_range = paste(range(Age)[1], "-", range(Age)[2]),
    mean_anxiety = mean(Anxiety, na.rm = TRUE),
    sd_anxiety = sd(Anxiety, na.rm = TRUE)
  )

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
