library(tidyverse)
library(lubridate)
library(purrr)
library(stringr)
library(forcats)


# clean_data is a pipeline function that calls four functions built 
## inside of the clean_data function.
## Those functions are clean_nulls, clean_stop_info, 
## clean_search_vars, and clean_other_vars

# The obvious implementation is `d <- get_all_data() %>% clean_data()

clean_data <- function(d) {
	
	clean_nulls <- function(d) {
		d[d == "NULL" | is.null(d) | d == "NULL ;"] <- NA
		d[is.null(d)] <- NA
		
		return(d)
	}
	
	clean_stop_info <- function(d) {
		
		#stop_type
		d$stop_type <- recode(d$stop_type,
													"Harbor" = "Harbor",
													"Non-ticket Stop" = "No Ticket",
													"Ticket Only" = "Ticket",
													"Ticket and Non-ticket Stop" = "Both"
		)
		
		#stop_date
		d <- mutate(d, stop_date = mdy(stop_date))
		
		#stop_time
		d <- d %>% 
			separate(col = stop_time, into = c("time_unformatted", "am_pm"), sep = " ", fill = "right") %>% 
			separate(col = time_unformatted, into = c("stop_time_hrs", "stop_time_mins"), sep = ":", convert = T) %>% 
			mutate(stop_time_hrs = ifelse(am_pm == "PM", stop_time_hrs+12, stop_time_hrs)) %>%
			select(-am_pm)
		
		#stop_location_block
		d <- mutate(d, stop_quadrant = str_squish(str_extract(stop_location_block, " NW | NE | SW | SE ")))
		
		#stop_district
		d <- mutate(d, stop_district = as.integer(str_remove_all(stop_district, "[^0-9]")))
		
		#stop_duration_mins
		d <- mutate(d, stop_duration_minutes = as.integer(str_remove_all(stop_duration_minutes, "[^0-9]")))
		
		#stop_reason_nonticket
		d <- mutate(d, stop_reason_nonticket = str_remove_all(stop_reason_nonticket, "[^[:punct:]|[:alnum:]|[ ]]"))
		
		return(d)
	}
	
	clean_search_vars <- function(d) {
		cols_to_logical <- c(
			"person_search_or_protective_pat_down",
			"property_search_or_protective_pat_down",
			"person_search_consent",
			"person_search_probable_cause",
			"person_protective_pat_down",
			"person_search_warrant",
			"person_search_consent",
			"property_search_probable_cause",
			"property_protective_pat_down",
			"property_search_warrant",
			"property_search_consent"
			)
		
		d <- d %>% mutate(across(.cols = all_of(cols_to_logical), .fns = as.logical))
		
		cols_small_cleaning <- c(
			"person_search_reason_consent",                
			"person_search_reason_probable_cause",         
			"person_protective_pat_down_reason",           
			"person_search_reason_warrant",                
			"property_search_reason_consent",              
			"property_search_reason_probable_cause",       
			"property_protective_pat_down_reason",         
			"property_search_reason_warrant",              
			"property_search_object_consent",              
			"property_search_object_probable_cause",       
			"property_protective_pat_down_object",         
			"property_search_object_warrant",              
			"person_search_object_seized_consent",         
			"person_search_object_seized_probable_cause",  
			"person_protective_pat_down_object_seized",    
			"person_search_object_seized_warrant",         
			"property_search_object_seized_consent",       
			"property_search_object_seized_probable_cause",
			"property_protective_pat_down_object_seized",  
			"property_search_object_seized_warrant"
		)
		
		d <- mutate(d, across(.cols = all_of(cols_small_cleaning), .fns = ~str_remove_all(., "[^[:punct:]|[:alnum:]|[ ]]")))
		
		return(d)
	}
	
	clean_other_vars <- function(d) {
		d <- mutate(d, across(.cols = contains("count"), .fns = as.integer))
		
		return(d)
	}
	
	d <- compose(clean_nulls, clean_stop_info, clean_search_vars, clean_other_vars, .dir = "forward")(d)
	
	return(d)
}



	