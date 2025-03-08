####INFERENTIAL STATISTICS

#clearing environment and loading libraries and data
rm(list = ls())
load("Processed Data/filtered_data.RData")
load("Processed Data/filtered_data_Singleplayer_only.RData")
library(ggplot2)
library(ggpubr)
library(pROC)

####PREDICTING ANXIETY BY HOURS PER WEEK AND PLAYSTYLE (LINEAR REGRESSION) ----

#Fit linear regression model
linear_model_Anxiety <- lm(data = filtered_data, Anxiety ~ Hours_per_week * Playstyle)
summary(linear_model_Anxiety)

#plotting linear regression results
linear_regression_result_graph <- ggplot(filtered_data, aes(x = Hours_per_week, y = Anxiety)) +
  stat_regline_equation(formula = filtered_data$Anxiety ~ filtered_data$Hours_per_week * filtered_data$Playstyle,
                        position = position_nudge(y = -10.5),
                        aes(label = after_stat(rr.label))) +
  geom_smooth(method = "lm", alpha = 0.2, aes(fill = Playstyle, color = Playstyle)) + 
  labs(
    title = "Predicting Anxiety by Hours per Week and Playstyle",
    subtitle = "confidence interval: 0.95",
    x = "Hours per Week",
    y = "Anxiety",
  ) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, max(filtered_data$Hours_per_week), by = 20),
                     minor_breaks = seq(0, max(filtered_data$Hours_per_week), by = 10)) +
  scale_y_continuous(breaks = seq(0, max(filtered_data$Anxiety), by = 1),
                     minor_breaks = seq(0, max(filtered_data$Anxiety), by = .5))

#saving linear regression results graph
ggsave("Graphs/Anxiety-Predicted-by-Hours-and-Playstyle.png", plot = linear_regression_result_graph)

####PREDICTING DAILY ANXIETY Debilitation BY HOURS PER WEEK AMONG SINGLEPLAYER GAMERS (LOGICAL REGRESSION) ----

#Fit logistic regression model
Logistic_Model_Anxiety_Debilitation <- glm(Anxiety_Debilitation ~ Hours_per_week, data = filtered_data_Singleplayer_only, family = "binomial")
summary(Logistic_Model_Anxiety_Debilitation)

#adding column of predicted probabilities
filtered_data_Singleplayer_only$Predicted_Prob <- predict(Logistic_Model_Anxiety_Debilitation, type = "response")

#roc curve fitting, plotting and saving image
roc_curve <- roc(filtered_data_Singleplayer_only, Anxiety_Debilitation, Predicted_Prob)

#image save start
png("Graphs/ROC_Curve.png", width = 800, height = 600)
plot.roc(
  roc_curve, col = "red", lwd = 3, 
  main = "ROC Curve for Anxiety Debilitation Model", 
  print.auc = TRUE, print.auc.col = "black",
  print.auc.cex = 1.2, print.auc.x = 1.15, print.auc.y = 0.95, cex.main = 1.5
  )
dev.off()
#image save end

#extracting odds ratio and 95% confidence interval
OR <- round(exp(coef(Logistic_Model_Anxiety_Debilitation)["Hours_per_week"]), 3)
OR_conf <- round(exp(confint(Logistic_Model_Anxiety_Debilitation)["Hours_per_week",]), 3)
OR_label = paste0("OR = ", OR, ", 95% CI: ", OR_conf[1], " - ", OR_conf[2])

#plotting logical regression results
high_anxiety_probability <- ggplot(filtered_data_Singleplayer_only, aes(x = Hours_per_week, y = Predicted_Prob)) +
  geom_point(alpha = 0.3) +  # Scatter plot of raw data
  geom_smooth(method = "glm", method.args = list(family = "binomial"), color = "blue") +
  labs(
    title = "Probability of High Anxiety Debilitation by Gaming Hours in Singleplayer",
    subtitle = "95% confidence interval",
    x = "Hours Spent Gaming per Week",
    y = "Predicted Probability of High Anxiety Debilitation"
  ) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, max(filtered_data_Singleplayer_only$Hours_per_week), by = 20),
                     minor_breaks = seq(0, max(filtered_data_Singleplayer_only$Hours_per_week), by = 10)) +
  scale_y_continuous(breaks = seq(0, 1, by = .1), minor_breaks = seq(0, 1, by = .05)) +
  annotate("text", x = max(filtered_data_Singleplayer_only$Hours_per_week) * 0.2, 
           y = 0.7, label = OR_label, size = 4.2)

#saving logistic regression results graph
ggsave("Graphs/Anxiety-Debilitation-Predicted-by-Hours-In-Singleplayer.png", plot = high_anxiety_probability)


