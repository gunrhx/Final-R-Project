####GENERAL FUNCTIONS SCRIPT ----

####DESCRIPTIVE SUMMARY FUNCTION----

descriptive_stats <- function(df) {
  
  #setting empty variables
  results_numeric = data.frame()
  results_categorial = data.frame()
  temp = data.frame()
  
  #loop for all column names
  for (name in names(df)) {
    
    #condition for numeric variables:
    if(typeof(df[[name]]) %in% c("integer", "double")) {
      temp <- data.frame(
        variable = name,
        range = paste(range(df$name, na.rm = TRUE)[1], "-", range(df[[name]], na.rm = TRUE)[2]),
        mean = mean(df[[name]], na.rm = TRUE),
        sd = sd(df[[name]], na.rm = TRUE)
      )
      results_numeric = rbind(results_numeric, temp)
      temp = data.frame()
    }
    
    #condition for character variables:
    else if(typeof(df[[name]]) == "character") {
      browser()
      temp_table <- table(df[[name]])
      counter = 1
      
      ##loop for categories in each character variable
      for (Levels in unique(df[[name]])) {
        
        temp <- data.frame(
          variable = name,
          categories = Levels,
          frequency = temp_table[counter]
        )
        counter = counter + 1
        
        results_categorial = rbind(results_categorial, temp)
        temp = data.frame()
      }
    }

  }
  return(list(results_numeric, results_categorial))
}


try_fun <- function(df) {
  
  library(dplyr)
  
  results_numeric <- raw_data |>
    select(where(is.numeric)) |>
    summarise(across(everything(), c(mean = mean, sd = sd), na.rm = TRUE))
  
  
  
  
  
}