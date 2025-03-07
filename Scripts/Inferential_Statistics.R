####INFERENTIAL STATISTICS

#loading data and libraries
rm(list = ls())
load("Processed Data/filtered_data.RData")
load("Processed Data/filtered_data_Singleplayer_only.RData")
library(ggplot2)
library(pROC)

####PREDICTING ANXIETY BY HOURS PER WEEK AND PLAYSTYLE (LINEAR REGRESSION) ----

#Fit linear regression model
linear_model_Anxiety <- lm(data = filtered_data, Anxiety ~ Hours_per_week * Playstyle)
summary(linear_model_Anxiety)

#plotting linear regression results
overall_effect_on_Anxiety <- ggplot(filtered_data, aes(x = Hours_per_week, y = Anxiety, color = Playstyle)) +
  geom_smooth(method = "lm", alpha = 0.2, aes(fill = Playstyle)) + 
  labs(
    title = "Predicting Anxiety by Hours per Week and Playstyle",
    subtitle = ""
    x = "Hours per Week",
    y = "Anxiety",
  ) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, max(filtered_data$Hours_per_week), by = 20), minor_breaks = seq(0, max(filtered_data$Hours_per_week), by = 10))


####PREDICTING DAILY ANXIETY DIFFICULTY BY HOURS PER WEEK AMONG SINGLEPLAYER GAMERS (LOGICAL REGRESSION) ----

#adding column of predicted probabilities
filtered_data_Singleplayer_only$Predicted_Prob <- predict(logistic_model_Anxiety_Difficulty, type = "response")

#Fit the logistic regression model
logistic_model_Anxiety_Difficulty <- glm(Anxiety_Difficulty ~ Hours_per_week, data = filtered_data_Singleplayer_only, family = "binomial")
summary(logistic_model_Anxiety_Difficulty)

#roc curve
roc_curve <- roc(filtered_data_Singleplayer_only, Anxiety_Difficulty, Predicted_Prob)
roc_curve$auc
plot.roc(roc_curve)

#plotting results
ggplot(filtered_data_Singleplayer_only, aes(x = Hours_per_week, y = Predicted_Prob)) +
  geom_point(alpha = 0.3) +  # Scatter plot of raw data
  geom_smooth(method = "glm", method.args = list(family = "binomial"), color = "blue") +
  labs(
    title = "Probability of High Anxiety Difficulty by Gaming Hours",
    x = "Hours Spent Gaming per Week",
    y = "Predicted Probability of High Anxiety Difficulty"
  ) +
  theme_minimal()
