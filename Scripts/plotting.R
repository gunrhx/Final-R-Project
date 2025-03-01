#clearing environment
rm(list = ls())
library(dplyr)
library(ggplot2)
library(ggdist)

####RETRIEVING DATA ----
main <- getwd()

#explicit data extraction
explicit_collected_data <- read.csv("explicit_data/explicit.csv")

#printing amount of people that started the experiment
paste("the amount of participants that started experiment: ", sum(as.logical(unique(explicit_collected_data$session_id))))

#completed sessions list
completed_sessions <- read.csv("ybalab.daniel.death1.0001/sessions.csv")
completed_sessions <- completed_sessions |>
  filter(session_status == "C")

#amount of participants that completed the experiment:
paste("the amount of participants that completed experiment: ",sum(as.logical(unique(completed_sessions$session_id))))

#filtering only completed sessions from collected data
explicit_raw_data <- explicit_collected_data |>
  filter(session_id %in% completed_sessions$session_id)

####EXPLORATIVE DATA VIEWING ----

#descriptive data of each condition
explicit_raw_data |>
  group_by(question_name, question_response) |>
  filter(questionnaire_name == "realstart") |>
  filter(question_name %in% c("target1State", "target1Group", "target2State", "target2Group")) |>
  summarise(n())

ggplot(raw_data_readable, aes(x = evaluation_mean, y = group, fill = state)) +
  stat_halfeye() +
  facet_wrap(state, nrow = 2, dir = "h")
  
#plotting evaluation mean (distirbution + boxplot)
ggplot(raw_data_readable, aes(x = evaluation_mean)) +
  stat_slabinterval(
    alpha = .6,
    fill = "blue",
    point_interval = "mean_qi",
  ) +
  geom_boxplot(
    width = .2,
    fill = "cyan",
    position = position_nudge(y = -.15)
  ) +
  labs(
    title = "Distribution + Boxplot of Evaluation Mean",
    y = "",
    x = "evaluation mean"
  ) +
  coord_cartesian(xlim = c(1, 7)) +
  theme_minimal() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

#histogram of all conditions
ggplot(raw_data_readable, aes(x = liking)) +
  geom_histogram() +
  labs(
    title = "Liking Histogram",
    x = "liking measurement",
    y = "frequency"
  )
  
