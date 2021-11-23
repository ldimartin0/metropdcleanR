library(readr)
library(dplyr)
library(purrr)

# Four functions for grabbing MPD data - get_year_data for 2019, 2020, and 2021, and get_all_data.

# Note that this file only loads the functions into working memory, it stores no variables/values and does not actually load the data. Source this file and then call these functions as you see fit.

get_yr_data <- function(year, export = F) {
	if (any(year < 2019) | any(year > 2021)) {return("MPD has not released stop data for years before 2019 and after 2021!")}
	
#### raw urls in here ####
	urls_2019 <- c(
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_09092019.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_1%20of%203.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_2%20of%203.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_3%20of%203.csv")
	urls_2020 <- c(
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_01012020-03142020%20%28Part%201%20of%202%29.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data_03152020-06302020%20%28Part%202%20of%202%29.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data%2C%2007012020-09302020%20%281%20of%202%29%20UPDATED.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/Stop%20Data%2C%2010012020-12312020%20%282%20of%202%29%20UPDATED.csv")
	urls_2021 <- c(
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/final_combined_stop_data_external_20210813_pt1.csv",
		"https://mpdc.dc.gov/sites/default/files/dc/sites/mpdc/publication/attachments/final_combined_stop_data_external_20210813_pt2.csv")
		
#### hard code for maintenance ####
	years <- 2019:2021
	urls_list <- list(urls_2019, urls_2020, urls_2021)
	
#### rest of function ####
	urls_df <- map2_dfr(years, urls_list, \(x, y){data.frame(x, y)})
	names(urls_df) <- c("years", "urls_vec")
	
	urls <- urls_df %>% 
		filter(years %in% year) %>% 
		pull(urls_vec)
	
	d <- data.frame()
	for (i in seq_along(urls)) {
		dest <- paste0("data", i, ".csv")
		download.file(urls[i], dest)
		
		d_temp <- read_csv(dest, show_col_types = F)
		d <- rbind(d, d_temp)
		
		sys_cmd <- paste("rm", dest, sep = " ")
		system(sys_cmd)
	}
	
	# 2019 includes a strange extra variable called observation, removing so that output is uniform
	if (2019 %in% year) {
		d <- select(d, -observation)
	}
	
	if (export) {
		file_prior <- paste("MPD_stop_data", year, sep = "_")
		con <- paste0(file_prior, ".csv")
		write.csv(d, con)
		print(paste("Complete! File saved to", con, "in", getwd()))
	}
	else if (!export) {
		print("Complete! File in working memory, export manually to save!")
	}
	
	return(d)
}

get_all_data <- function(export = F) {
	d <- get_yr_data(year = 2019:2021, export = export)
	
	return(d)
}

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
