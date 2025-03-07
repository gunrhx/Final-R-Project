####GENERAL FUNCTIONS SCRIPT

####DESCRIPTIVE DATA FRAME SUMMARY FUNCTION----

#This function takes a data frame as input and returns a summary of its numeric and categorical variables.
#Numeric variables are summarized with their range, mean, and standard deviation.
#Categorical variables (including factors) are summarized with frequency counts, excluding highly unique values.

descriptive_statistics <- function(df) {
  
  #converting factor variables to character
  df <- df |> mutate(across(where(is.factor), as.character))
  
  #numeric columns summary
  numeric_cols <- df[sapply(df, is.numeric)]
  if (ncol(numeric_cols) > 0) {
    numeric_summary <- data.frame(
      Variable = names(numeric_cols),
      Range = sapply(numeric_cols, function(x) {
        rounded_range <- round(range(x, na.rm = TRUE), 2)
        paste0(rounded_range[1], " - ", rounded_range[2])
      }),
      Mean = sapply(numeric_cols, function(x) round(mean(x, na.rm = TRUE), 2)),
      SD = sapply(numeric_cols, function(x) round(sd(x, na.rm = TRUE), 2))
    )
    #deleting duplicate variable name columns
    rownames(numeric_summary) <- NULL
  } else {
    numeric_summary <- NULL
  }
  
  #character columns summary (without columns with mostly unique values)
  char_cols <- df[sapply(df, is.character)]
  char_cols <- char_cols[, sapply(char_cols, function(x) length(unique(x)) < (0.5 * length(x))), drop = FALSE]
  
  char_summary <- list()
  
  if (ncol(char_cols) > 0) {
    char_summary <- lapply(names(char_cols), function(col) {
      char_table <- as.data.frame(table(df[[col]], useNA = "ifany"))
      colnames(char_table) <- c("Levels", "Frequency")
      return(char_table)
    })
    names(char_summary) <- names(char_cols)
  }
  
  #return both summaries as a list
  return(list(Numeric_Summary = numeric_summary, Character_Summary = char_summary))
}

#example usage:
#results <- descriptive_statistics(your_dataframe)
#View(results$Numeric_Summary)
#View(results$Character_Summary)
# View(results$Character_Summary$Specific_Variable)