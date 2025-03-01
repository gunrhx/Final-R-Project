try2 <- explicit_raw_data |>
  filter(question_name %in% c("jameslike", "jamestrst", "jamesfrnd", "brianlike", "briantrst", "brianfrnd")) |>
  mutate(target = ifelse(question_name %in% c("jameslike", "jamestrst", "jamesfrnd"), 1, 2)) |>
  group_by(session_id, target) |>
  summarise(evaluation = mean(as.numeric(question_response), na.rm = TRUE), .groups = "drop")




#factoring group (ref = "ingroup")
temp <- explicit_raw_data |>
  filter(question_name %in% c("target1Group", "target2Group", "target1State", "target2State")) |>
  group_by(session_id) |>
  reframe(
    target = ifelse(question_name %in% c("target1Group", "target1State"), 1, 2),
    group = factor(case_when(
      question_name %in% c("target1Group", "target2Group") &
        question_response == "France" &
        questionnaire_name == "realstart" ~ "outgroup",
      question_name %in% c("target1Group", "target2Group") &
        question_response == "USA" &
        questionnaire_name == "realstart" ~ "ingroup"),
    )
  ) |>
  filter(!is.na(group))

#factoring state (ref = "alive")
temp2 <- explicit_raw_data |>
  filter(question_name %in% c("target1Group", "target2Group", "target1State", "target2State")) |>
  group_by(session_id) |>
  reframe(
    target = ifelse(question_name %in% c("target1Group", "target1State"), 1, 2),
    state = factor(case_when(
      question_name %in% c("target1State", "target2State") &
        question_response == "alive" &
        questionnaire_name == "realstart" ~ "alive",
      question_name %in% c("target1State", "target2State") &
        question_response == "dead" &
        questionnaire_name == "realstart" ~ "dead")
    )
  ) |>
  filter(!is.na(state))
explicit_raw_data$group <- relevel(explicit_raw_data$group, ref = "ingroup")
explicit_raw_data$state <- relevel(explicit_raw_data$state, ref = "alive")

#creating evaluations data
temp4 <- explicit_raw_data |>
  filter(question_name %in% c("jameslike", "jamestrst", "jamesfrnd", "brianlike", "briantrst", "brianfrnd")) |>
  filter(questionnaire_name == "exp") |>
  mutate(target = ifelse(question_name %in% c("jameslike", "jamestrst", "jamesfrnd"), 1, 2)) |>
  group_by(session_id, target) |>
  reframe(
    evaluation = mean(as.numeric(question_response), na.rm = TRUE)
  )


evaluation = 
  mean(as.numeric(explicit_raw_data$question_response[
    explicit_raw_data$session_id == subject &
      explicit_raw_data$question_name %in% c("jameslike", "jamestrst", "jamesfrnd")]))


temp3 <- full_join(temp, temp4, by = c("session_id", "target"))
temp5 <- full_join(temp3, temp2, by = c("session_id", "target"))

#checking final data is good  
temp5 |>
  group_by(session_id) |>
  filter(n()!=2)

