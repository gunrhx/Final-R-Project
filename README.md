# Final-R-Project: Gaming Survey Data Research Analysis
 
## General Information
This data was collected from gamers worldwide. I picked it because I really enjoy gaming, and have always wondered about the negative label it people put on it. It is mostly researched as an anxiety inducing practice, socially isolating, etc. I believe that, as most things in life, it depends on many variables, and that the negative effects don't neccessarily comes from gaming, but more from being online. That's one thing I set to research from this analysis.

## Research Question
What is the relationship between anxiety and it's debilitating effect, particularly in terms of time investment and social gaming preferences?
To answer this question, I've tested the association between self-reported anxiety levels, hours spent gaming per month and gaming online (multiplayer) or offline (singleplayer). In addition, I've tested the association between the perceived debilitating effect of anxiety and hours played specifically in singleplayer offline gamers.

My hypothesys are that gaming more hours alone would not predict higher anxiety, but that gaming more would be assiciated with increased anxiety only when playing online, and not while playing singleplayer. In addition, I hypothesize that in the singleplayer population, gaming more would have be associated with a decreased anxiety debilitating effect.

Final R project: research question, data processing, results and conclusions

## Data Processing and Filtering Notes
### Required Packeges
To run my analysis on your own and view the non-attached graphs, you will need Rstudio or another program that runs R, and the following packages:
1. ggplot2
2. dplyr
3. patchwork
4. pROC
If you don't have any of these, you can run the following command in Rstudio:
```r
install.packages("name_of_package")
```

### Excluded Data
For my research, I had removed all participants that answered "other" in any of the survey questions, since they wouldn't fit any specific category in my analysis. In addition, anyone that reported playing more hours than two SD's of hours per month (144) was also excluded, on the basis of being too extreme. Lastly, anyone that didn't answer one of the analysis based questions (Generalised Anxiety Disorder Assessment, anxiety debilitating effect, hours per month gaming or playing single/multiplayer) was also excluded.
Amount who completed the survery: 13464
Amount after filtering:           12041

## Data Analysis
### Inferential Statistics
For my analysis, I used two regressions:
1. Multiple Linear Regression: predicting anxiety using hours gaming per month, playstyle (single/multiplayer) and their interaction.
2. Logistic Regression: predicting anxiety dibilitating properties using hours gaming per month, in singleplayer population only.

### Results
As was hypothesized, more gaming hours were associated with anxiety mostly in the population playing multiplayer (.037 increase in anxiety per hour), an effect that was almost completely attenuated in the population playing singleplayer (.032 decrease in anxiety per hour). Against my second hypothesis, in the singleplayer population gaming more hours was associated with more debilitating anxiety effects  

## Conclusions



