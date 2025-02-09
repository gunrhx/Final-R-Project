try <- read.csv("ybalab.daniel.death1.0001/sessions.csv")

View(try)

completed <- try |>
  filter(session_status == "C")

try3 <- iat_raw_data |>
  filter(session_id %in% completed$session_id) |>
  filter(block_name != "BLOCK1", block_name != "BLOCK2", block_name != "BLOCK3", block_name != "BLOCK4") |>
  filter(block_name != "null|", !grepl("null" ,block_pairing_definition))

try4 <- try3 |>
  group_by(session_id) |>
  filter(n() != 180) |>
  summarise(n())

unique(try3$block_pairing_definition)
unique(try3$task_name)
unique(try3$block_name)


missing_rows <- anti_join(try3, iat_data, by = "session_id")
n_distinct(try3$session_id)
n_distinct(iat_data$session_id)
n_distinct(missing_rows$session_id)

unique(missing_rows$block_pairing_definition)


iat_raw_data |>
  filter(session_id == "7314282")
