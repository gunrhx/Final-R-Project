####RETRIEVING IAT DATA ----
getwd()
iat_raw_data <- read.csv("iat_data/iat.csv")

####FILTERING RAW DATA ----

#filtering out irrelevant blocks and columns
iat_data <- iat_raw_data |>
  select(-c(study_name, trial_response)) |>
  filter(block_name != "BLOCK1", block_name != "BLOCK2", block_name != "BLOCK3", block_name != "BLOCK4") |>
  filter(block_name != "null|", !grepl("null" ,block_pairing_definition))

#filtering out participants that didn't finish the experiment
iat_data <- iat_data |>
  group_by(session_id) |>
  filter(n() == 180) |>
  ungroup()

####ANALYSING IAT DATA ----

#install.packages("IATscores")
library(IATscores)


unique(iat_data$block_name)
unique(iat_data$task_name)
unique(iat_data$block_pairing_definition)
unique(iat_data$block_number)

View(iat_data |>
  group_by(block_number) |>
  reframe(unique(block_pairing_definition)))
