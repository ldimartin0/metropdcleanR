library(tidyverse)
library(stringi)
library(stringr)

get_pop_data <- function() {
 d <- import("data/QuickFacts Oct-10-2021.csv")
 return(d)
}

clean_pop_data <- function(d) {
  d <- d %>% clean_names() %>% filter(
    district_of_columbia != ""
  )
  d <- select(d, c("fact", "value" = "district_of_columbia"))
}

clean_str <- function(str) {
    str <- str_remove_all(str, "[^0-9.-]")
    str <- as.double(str)
  return(str)
}

clean_value <- function(str) {
  if (str_detect(string = str, "%")) {
    str <- clean_str(str)*(1/100)
  }
  else {
    str <- clean_str(str)
  }
  return(str)
}

clean_value_vec <- function(d) {
  d$value <- map_dbl(d$value, clean_value)
  return(d)
}

pivot_pop_data <- function(d) {
  d <- pivot_wider(d, names_from = fact, values_from = value) %>% clean_names
  return(d)
}

select_data <- function(d) {
  d <- select(d, 
    "native" = "american_indian_and_alaska_native_alone_percent",
    "black" = "black_or_african_american_alone_percent",
    "asian" = "asian_alone_percent",
    "latino" = "hispanic_or_latino_percent",
    "white" = "white_alone_not_hispanic_or_latino_percent",
    "pacific_islander" = "native_hawaiian_and_other_pacific_islander_alone_percent"
    )
  d <- pivot_longer(d, cols = everything(), names_to = "race", values_to = "pct")
  return(d)
}

export_pop_data <- function() {
  d <- get_pop_data() %>% clean_pop_data() %>% clean_value_vec() %>% pivot_pop_data() %>% select_data()
  export(d, "data_cleaned/pop_data_cleaned.csv")
}

export_pop_data()
