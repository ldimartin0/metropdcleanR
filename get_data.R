library(readr)
library(dplyr)

# Four functions for grabbing MPD data - get_year_data for 2019, 2020, and 2021, and get_all_data.

# Note that this file only loads the functions into working memory, it stores no variables/values and does not actually load the data. Source this file and then call these functions as you see fit.

get_2019_data <- function() {
	urls <- c(
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_09092019.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_1%20of%203.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_2%20of%203.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_3%20of%203.csv")

	d <- data.frame()
	for (i in seq_along(urls)) {
		dest <- paste0("data", i, ".csv")
		download.file(urls[i], dest)
		
		d_temp <- read_csv(dest, show_col_types = F)
		d <- rbind(d, d_temp)
		
		sys_cmd <- paste("rm", dest, sep = " ")
		system(sys_cmd)
	}
	
	return(d)
}

get_2020_data <- function() {
	urls<- c(
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_01012020-03142020%20%28Part%201%20of%202%29.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_03152020-06302020%20%28Part%202%20of%202%29.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data%2C%2007012020-09302020%20%281%20of%202%29%20UPDATED.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data%2C%2010012020-12312020%20%282%20of%202%29%20UPDATED.csv")
	
	d <- data.frame()
	for (i in seq_along(urls)) {
		dest <- paste0("data", i, ".csv")
		download.file(urls[i], dest)
		
		d_temp <- read_csv(dest, show_col_types = F)
		d <- rbind(d, d_temp)
		
		sys_cmd <- paste("rm", dest, sep = " ")
		system(sys_cmd)
	}
	
	return(d)
}

get_2021_data <- function() {
	urls<- c(
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/final_combined_stop_data_external_20210813_pt1.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/final_combined_stop_data_external_20210813_pt2.csv"
		)
	
	d <- data.frame()
	for (i in seq_along(urls)) {
		dest <- paste0("data", i, ".csv")
		download.file(urls[i], dest)
		
		d_temp <- read_csv(dest, show_col_types = F)
		d <- rbind(d, d_temp)
		
		sys_cmd <- paste("rm", dest, sep = " ")
		system(sys_cmd)
	}
	
	return(d)
}

get_all_data <- function() {
	d19 <- get_2019_data()
	d20 <- get_2020_data()
	d21 <- get_2021_data()
	
	# Since MPD conveniently added an observation variable to the 2019 data, that must be removed
	d19 <- select(d19, -observation)
	
	d <- rbind(d19, d20, d21)
	
	return(d)
}
