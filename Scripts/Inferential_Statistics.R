####INFERENTIAL STATISTICS

#loading data and libraries
load("Processed Data/filtered_data.RData")
load("Processed Data/filtered_data_filtered_data_Singleplayer_only.RData")
library(ggplot2)
library(pROC)

####PREDICTING ANXIETY BY HOURS PER WEEK AND PLAYSTYLE ----

#Fit linear regression
linear_model_Anxiety <- lm(data = filtered_data, Anxiety ~ Hours_per_week * Playstyle)
summary(linear_model_Anxiety)

####PLOTTING RESULTS

#hours main effect on anxiety
main_effect_hours <- ggplot(filtered_data, aes(x = Hours_per_week, y = Anxiety)) +
  geom_smooth(method = "lm", alpha = .2) + 
  labs(
    title = "Predicting Anxiety by Hours per Week",
    x = "Hours per Week",
    y = "Anxiety",
  ) +
  theme_minimal()

#playstyle main effect on anxiety is not very interesting to see, since it relates
#to hours per week at 0. Therefore, I did not attach this graph.

#overall effect with all variables
overall_effect_on_Anxiety <- ggplot(filtered_data, aes(x = Hours_per_week, y = Anxiety, color = Playstyle)) +
  geom_smooth(method = "lm", alpha = 0.2, aes(fill = Playstyle)) + 
  labs(
    title = "Predicting Anxiety by Hours per Week and Playstyle",
    x = "Hours per Week",
    y = "Anxiety",
  ) +
  theme_minimal()
main_effect_hours/overall_effect_on_Anxiety

####PREDICTING DAILY ANXIETY DIFFICULTY BY HOURS PER WEEK ON SINGLEPLAYER GAMERS ----

#Fit the logistic regression model
logistic_model_Anxiety_Difficulty <- glm(Anxiety_Difficulty ~ Hours_per_week, data = filtered_data_Singleplayer_only, family = "binomial")
summary(logistic_model_Anxiety_Difficulty)

#roc curve
roc_curve <- roc(filtered_data_Singleplayer_only$Anxiety_Difficulty, predict(logistic_model_Anxiety_Difficulty, type = "response"))
roc_curve$auc
plot.roc(roc_curve)
