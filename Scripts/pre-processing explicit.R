rm(list = ls())

####RETRIEVING DATA ----
main <- getwd()
library(dplyr)

#explicit data extraction
explicit_collected_data <- read.csv("explicit_data/explicit.csv")

####TRYING THINGS ----

#unique values checks
unique(explicit_collected_data$questionnaire_name)
unique(explicit_collected_data$question_name)
unique(explicit_collected_data$attempt)
sum(as.logical(unique(explicit_collected_data$session_id)))
unique(explicit_collected_data$study_name)
unique(explicit_collected_data$question_response)

#completed sessions list
completed_sessions <- read.csv("ybalab.daniel.death1.0001/sessions.csv")
completed_sessions <- completed_sessions |>
  filter(session_status == "C")

#amount of participants that completed the sessions:
paste("the amount of participants that completed experiment: ",sum(as.logical(unique(completed_sessions$session_id))))

#filtering only completed sessions from collected data
explicit_raw_data <- explicit_collected_data |>
  filter(session_id %in% completed_sessions$session_id)
  

#filtering irrelevant data
explicit_raw_data <- explicit_raw_data |>
  select(-study_name, -attempt, -task_number, -question_number) |>
  filter(questionnaire_name %in% c("realstart", "exp")) |>
  filter(!(session_id %in% c(7332779, 7314282, 7324703)))

temp <- explicit_data1 |>
  filter(grepl("like", question_name), !grepl("rt", question_name))
unique(temp$question_name)


#descriptive data of each condition
explicit_raw_data |>
  group_by(question_name, question_response) |>
  filter(questionnaire_name == "realstart") |>
  filter(question_name %in% c("target1State", "target1Group", "target2State", "target2Group")) |>
  summarise(n())

#factoring group (ref = "ingroup") and state (ref = "alive")
explicit_raw_data <- explicit_raw_data |>
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
explicit_raw_data$group <- relevel(explicit_raw_data$group, ref = "ingroup")
explicit_raw_data$state <- relevel(explicit_raw_data$state, ref = "alive")

#creating new arranged data frame
try <- data.frame()
for (subject in unique(explicit_raw_data$session_id)) {
  temp1 <- data.frame(
    subj = 
      subject,
    group = 
      explicit_raw_data$group[explicit_raw_data$session_id == subject &
                              explicit_raw_data$question_name == "target1Group" &
                              explicit_raw_data$questionnaire_name == "realstart"],
    state = 
      explicit_raw_data$state[explicit_raw_data$session_id == subject &
                              explicit_raw_data$question_name == "target1State" &
                              explicit_raw_data$questionnaire_name == "realstart"],
    evaluation = 
      mean(as.numeric(explicit_raw_data$question_response[
      explicit_raw_data$session_id == subject &
      explicit_raw_data$question_name %in% c("jameslike", "jamestrst", "jamesfrnd")]))
  )
  temp2 <- data.frame(
    subj = subject,
    group = explicit_raw_data$group[explicit_raw_data$session_id == subject &
                                    explicit_raw_data$question_name == "target2Group" &
                                    explicit_raw_data$questionnaire_name == "realstart"],
    state = explicit_raw_data$state[explicit_raw_data$session_id == subject &
                                    explicit_raw_data$question_name == "target2State" &
                                    explicit_raw_data$questionnaire_name == "realstart"],
    evaluation = mean(as.numeric(explicit_raw_data$question_response[
      explicit_raw_data$session_id == subject &
      explicit_raw_data$question_name %in% c("brianlike", "briantrst", "brianfrnd")]))
  )
  try <- rbind(try, temp1, temp2)
}

#checking that everyone has exactly 2 rows
try |>
  group_by(subj) |>
  filter(n() != 2)

#doesn't have realstart data
temp<- explicit_raw_data |>
  filter(session_id == "7314282")
#doesn't have any likert scale judgement
temp<- explicit_raw_data |>
  filter(session_id == "7324703")

temp <- explicit_raw_data |>
  group_by(session_id) |>
  filter(n() < 23) |>
  summarise(n())
unique(temp$`n()`)

mean(explicit_raw_data$question_response[explicit_raw_data$question_name %in% c("jameslike", "jamestrst", "jamesfrnd")])


