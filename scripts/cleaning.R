remove_harbor <- function(d) {
  d <- d %>% filter(
    stop_type!= "Harbor"
  )
  return(d)
}

rename_race <- function(d) {
  names(d)[names(d) == "race_ethnicity"] <- "race"
  return(d)
}

create_race_2 <- function(d) {
  d <- d %>% mutate(
  race_2 = ifelse(race %in% c("Asian", "Black", "Hispanic", "Multiple"), "POC", ifelse(race == "White", "White", "Other"))
)
  return(d)
}

}

