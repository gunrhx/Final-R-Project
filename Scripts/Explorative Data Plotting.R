####EXPLORATIVE DATA PLOTTING

#clearing environment and loading libraries and data
rm(list = ls())
load("Processed Data/simple_raw_data.RData")
library(dplyr)
library(ggplot2)
library(patchwork)

#creating anxiety summary dataset for plotting
whyplay_gender_anxiety_summary <- simple_raw_data |>
  filter(Gender != "Other") |>
  group_by(Whyplay, Gender) |>
  summarise(
    mean = mean(Anxiety),
    sd = sd(Anxiety)
  )

####PLOTTING ----

####REGRESSION PLOTS ----

#anxiety predicted by hours per week, divided by gender
anxiety_by_hours_per_gender <- ggplot(simple_raw_data, aes(x = Hours_per_week, y = Anxiety, fill = Gender, color = Gender)) +
  geom_smooth(method = "lm", level = .9) +
  xlim(0, 160) +
  labs(
    title = "Anxiety Predicted by Hours-per-week Divided by Gender",
    subtitle = "confidence interval: 0.9",
    x = "Hours per week",
    y = "Anxiety"
  ) +
  theme_minimal()

#anxiety predicted by hours per week predicting, divided by playstyle
anxiety_by_hours_per_playstle <- ggplot(simple_raw_data, aes(x = Hours_per_week, y = Anxiety, fill = Playstyle, color = Playstyle)) +
  geom_smooth(method = "lm", level = .95) +
  xlim(0,160) +
  labs(
    title = "Anxiety Predicted by Hours-per-week Divided by Playstyle",
    subtitle = "confidence interval: 0.95",
    x = "Hours per week",
    y = "Anxiety"
  ) +
  theme_minimal()

####OTHER PLOTS----

#bar plot of reasons for playing by playstyle, converted to percentages for direct comparison
bars_gaming_reason_by_playstyle <- ggplot(simple_raw_data, aes(x = Whyplay, fill = Playstyle)) +
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

#boxplots of social anxiety by playstyle
boxplot_social_anxiety_by_playstyle <- ggplot(simple_raw_data , aes(x = Social_Anxiety, fill = Playstyle)) +
  stat_boxplot(position = "dodge") +
  labs(
    title = "Social Anxiety Divided by Playstyle",
    x = "Social Anxiety"
  ) +
  theme_minimal() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  scale_x_continuous(breaks = seq(0, max(simple_raw_data$Social_Anxiety), by = 10),
                     minor_breaks = seq(0, max(simple_raw_data$Social_Anxiety), by = 5))

#anxiety, well being and social anxiety densities
anxiety_density <- ggplot(simple_raw_data, aes(x = Anxiety)) + 
  geom_density(fill = "skyblue", alpha = .6) +
  labs(title = "Density of Anxiety", x = "Anxiety Level", y = "Density") +
  theme_minimal()

social_anxiety_density <- ggplot(simple_raw_data, aes(x = Social_Anxiety)) + 
  geom_density(fill = "lightgreen", alpha = .6) +
  labs(title = "Density of Social Anxiety", x = "Social Anxiety Level", y = "Density") +
  theme_minimal()

well_being_density <- ggplot(simple_raw_data, aes(x = Well_Being)) + 
  geom_density(fill = "lightyellow", alpha = .6) +
  labs(title = "Density of Well-Being", x = "Well-Being Level", y = "Density") +
  theme_minimal()

##anxiety, well being and social anxiety density viewed one under the other
anxiety_and_well_being_densities <- (anxiety_density | social_anxiety_density | well_being_density) +
  plot_annotation(
    title = "Comparison of Anxiety, Social Anxiety, and Well-Being Densities",
    caption = "Note: all measured by different questionnaires"
  )

#jitter and errorbars of anxiety by gender and reason to play
errorbars_anxiety_by_gender_and_playstyle <- ggplot(whyplay_gender_anxiety_summary, aes(x = Whyplay, y = mean, color = Whyplay)) +
  geom_point(size = 5, position = position_dodge(1)) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = .5, linewidth = 1.3, position = position_dodge(1)) +
  geom_jitter(data = simple_raw_data |> filter(Gender != "Other"), aes(y = Anxiety), alpha = .1) +
  theme_classic() +
  labs(
    title = "Anxiety Scores by Gender and Reason to Play",
    subtitle = "means and error bars with jitter",
    y = "Anxiety",
    x = "Reasons to play",
    caption = "note: specified 'other' gender was removed from analysis"
  ) +
  facet_wrap(~Gender)