#clearing environment and loading libraries
rm(list = ls())
library(dplyr)

#General Comment:
##The data collected data was very disorganized, and had many mistakes and
##duplicates. That's why the transfer to raw_data was a bit convoluted.

####RETRIEVING DATA ----

#collected data extraction
collected_data <- read.csv("Collected Data/explicit.csv")

#printing amount of people that started the experiment
paste("the amount of participants that started experiment: ",
      sum(as.logical(unique(collected_data$session_id))))

#completed sessions list
completed_sessions <- read.csv("Collected Data/sessions.csv")
completed_sessions <- completed_sessions |>
  filter(session_status == "C")

#printing amount of participants that completed the experiment:
paste("the amount of participants that completed experiment: ",
      sum(as.logical(unique(completed_sessions$session_id))))

####RAW DATA FILTERING ----

#filtering only completed sessions from collected data
raw_data <- collected_data |>
  filter(session_id %in% completed_sessions$session_id)
  

#filtering irrelevant and missing data
raw_data <- raw_data |>
  select(-study_name, -attempt, -task_number, -question_number) |>
  group_by(session_id) |>
  filter(all(c("realstart", "exp", "iat") %in% questionnaire_name)) |>
  filter("score" %in% question_name, !"." %in% question_response) |>
  filter(questionnaire_name %in% c("realstart", "exp", "iat")) |>
  ungroup()

#printing amount of participants after filtering
paste("the amount of participants that completed experiment with no errors: ",
      sum(as.logical(unique(raw_data$session_id))))

#descriptive data of each condition
raw_data |>
  group_by(question_name, question_response) |>
  filter(question_name %in% c("target1State", "target1Group", "target2State", "target2Group")) |>
  summarise(amount = n())

#factoring group (ref = "ingroup") and state (ref = "alive")
raw_data <- raw_data |>
  mutate(
    group = factor(case_when(
      question_name %in% c("target1Group", "target2Group") &
      question_response == "France" &
      questionnaire_name == "realstart" ~ "outgroup",
      question_name %in% c("target1Group", "target2Group") &
      question_response == "USA" &
      questionnaire_name == "realstart" ~ "ingroup")
      ),
    state = factor(case_when(
      question_name %in% c("target1State", "target2State") &
      question_response == "alive" &
      questionnaire_name == "realstart" ~ "alive",
      question_name %in% c("target1State", "target2State") &
      question_response == "dead" &
      questionnaire_name == "realstart" ~ "dead")
    )
  )
raw_data$group <- relevel(raw_data$group, ref = "ingroup")
raw_data$state <- relevel(raw_data$state, ref = "alive")

#arranging the data frame
raw_data_organized <- data.frame()
for (subject in unique(raw_data$session_id)) {
  temp1 <- data.frame(
    subj = subject,
    target = 1,
    group = raw_data$group[raw_data$session_id == subject &
            raw_data$question_name == "target1Group"],
    
    state = raw_data$state[raw_data$session_id == subject &
            raw_data$question_name == "target1State"],
    
    liking = as.numeric(raw_data$question_response[
             raw_data$session_id == subject &
             raw_data$question_name == "jameslike"]),
    
    trust = as.numeric(raw_data$question_response[
            raw_data$session_id == subject &
            raw_data$question_name == "jamestrst"]),
    
    friendly = as.numeric(raw_data$question_response[
               raw_data$session_id == subject &
               raw_data$question_name == "jamesfrnd"]),
    
    evaluation_mean = mean(as.numeric(raw_data$question_response[
                      raw_data$session_id == subject &
                      raw_data$question_name %in% c("jameslike", "jamestrst", "jamesfrnd")])),
    
    clean_IAT = as.numeric(raw_data$question_response[raw_data$session_id == subject &
                raw_data$question_name == "score"])
  )
  temp2 <- data.frame(
    subj = subject,
    target = 2,
    group = raw_data$group[raw_data$session_id == subject &
            raw_data$question_name == "target2Group"],
    
    state = raw_data$state[raw_data$session_id == subject &
            raw_data$question_name == "target2State"],
    
    liking = as.numeric(raw_data$question_response[
             raw_data$session_id == subject &
             raw_data$question_name == "brianlike"]),
    
    trust = as.numeric(raw_data$question_response[
            raw_data$session_id == subject &
            raw_data$question_name == "briantrst"]),
    
    friendly = as.numeric(raw_data$question_response[
               raw_data$session_id == subject &
               raw_data$question_name == "brianfrnd"]),
    
    
    evaluation_mean = mean(as.numeric(raw_data$question_response[
                      raw_data$session_id == subject &
                      raw_data$question_name %in% c("brianlike", "briantrst", "brianfrnd")])),
    
    clean_IAT = temp1$clean_IAT
  )
  raw_data_organized <- rbind(raw_data_organized, temp1, temp2)
}

#save processed raw data
save(raw_data_organized, file = "processed data/raw_data_organized.RData")
