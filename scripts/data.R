library(dplyr)
library(tidyr)
library(lubridate)
library(rio)
library(forcats)
library(janitor)
library(stringr)

get_data <- function () {
  paths <- Sys.glob("../data/*.csv")
  list <- import_list(paths)
  d <- do.call(rbind, list) %>% as_tibble
  return(d)
}

clean_names <- function(d) {
  d <- janitor::clean_names(d)
  return(d)
}

clean_data_by_col <- function(d) {
  d <- as_tibble(d)
  
  # change names for ease
  names(d)[names(d) == "race_ethnicity"] <- "race"

  
  # change to NA's
  d[d == "NULL" | is.null(d) | d == "NULL ;"] <- NA
  d[is.null(d)] <- NA
  
  # refactor stop_type
  d$stop_type <- recode(d$stop_type,
                        "Harbor" = "Harbor",
                        "Non-ticket Stop" = "No Ticket",
                        "Ticket Only" = "Ticket",
                        "Ticket and Non-ticket Stop" = "Both"
  )
  
  # clean date variables
  d <- mutate(d, arrest_date = mdy(arrest_date))
  d <- mutate(d, stop_date = mdy(stop_date))
  
  # stop_time
  d <- separate(d, stop_time, sep = ":", into = c("stop_time_hrs", "stop_time_mins"))
                
  # stop_district
  d <- mutate(d, stop_district = str_remove_all(stop_district, "[^0-9]"))
  d <- mutate(d, stop_district = if_else(stop_district == "", NA, stop_district))
  
  
  
  
  
  
  
  




clean_data <- function(d) {
  # names(d)[names(d) == "race_ethnicity"] <- "race"
  # d$stop_type <- recode(d$stop_type,
  #             "Harbor" = "Harbor",
  #             "Non-ticket Stop" = "No Ticket",
  #             "Ticket Only" = "Ticket",
  #             "Ticket and Non-ticket Stop" = "Both"
  # )
  # 
  # d <- select(d,
  #             ccn_anonymized, 
  #             stop_type,
  #             stop_district,
  #             "stop_duration" = "stop_duration_minutes",
  #             stop_reason_nonticket,
  #             stop_reason_ticket,
  #             "pers_search" = "person_search_or_protective_pat_down",
  #             "pers_search_consent" = "person_search_consent",
  #             "pers_search_pc" = "person_search_probable_cause",
  #             "pers_search_warrant" = "person_search_warrant",
  #             tickets_issued,
  #             warnings_issued,
  #             ticket_count,
  #             warning_count,
  #             arrest_charges,
  #             gender,
  #             race,
  #             age,
  #             arrest_date,
  #             stop_date,
  #             stop_time,
  #             everything()
  # )
  
  d <- mutate(d,
              pers_search_non_consent = ifelse(pers_search_pc == T | pers_search_warrant == T, T, F)
  )
  d <- as_tibble(d)
  return(d)
}

fix_columns <- function(d) {
  # to NA
  d[d == "NULL"] <- NA
  # to factor
  vars_to_factor <- c("stop_type", "stop_reason_nonticket", "stop_reason_ticket", "arrest_charges", "gender", "race")
  d <- d %>% mutate_at(vars_to_factor, as_factor) %>% 
    as_tibble()
  
  # to numeric
  vars_to_numeric <- c("stop_duration", "pers_search", "pers_search_consent", "pers_search_pc", "pers_search_warrant", "ticket_count", "warning_count")
  d <- d %>% 
    mutate_at(vars_to_numeric, as.numeric) %>% 
    as_tibble()
  
  # stop_district
  d$stop_district <- str_remove_all(d$stop_district, "[^0-9]")
  
 
  # age
  d <- mutate(d, juvenile = if_else(age == "Juvenile", 1, 0))
  d$age[d$age == "Juvenile"] <- 17
  d$age[d$age == "Unknown"] <- NA
  d$age <- as.numeric(d$age)
  # race
  levels(d$race) <- tolower(levels(d$race))
  # arrest
  d <- mutate(d, arrest = if_else(as.character(arrest_charges) == "", 0, 1))
  
  # time
  d <- mutate(d, 
              hrs = as.numeric(str_replace_all(stop_time, ":[0-9]{1,2}", "")),
              mins = as.numeric(str_replace_all(stop_time, "[0-9]{1,2}:", "")),
              t_mins = hrs*60 + mins
  )
  return(d)
}

export_d <- function() {
  d <- get_data() %>% clean_data() %>% fix_columns()
  export(d, file = "data_cleaned/stop_data_cleaned.csv")
}

# run export_d() to generate cleaned data, only need to run it once
