library(readr)
library(dplyr)
library(purrr)
library(magrittr)

#' Get MPD Data
#'
#' This function grabs stop data from Metropolitan Police Department's website and loads into working memory, and optionally exports that data.
#'
#' @param year An integer vector of year(s) to access data from; the only available years of data are 2019 to 2021.
#' @param export A logical binary to determine whether data is exported into working directory as CSV. Default `F` means data is only loaded into working memory and must be exported by user.
#'
#' @return A dataframe. Clean data with [metropdcleanR::clean_data()].
#' @export
#'
#' @examples
#' d <- get_yr_data(2019:2020)
#' get_yr_data(2021, export = TRUE)
get_yr_data <- function(year, export = FALSE) {
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
	urls_df <- purrr::map2_dfr(years, urls_list, \(x, y){data.frame(x, y)})
	names(urls_df) <- c("years", "urls_vec")

	urls <- urls_df %>%
		dplyr::filter(years %in% year) %>%
		dplyr::pull(urls_vec)

	d <- data.frame()
	for (i in seq_along(urls)) {
		dest <- paste0("data", i, ".csv")
		utils::download.file(urls[i], dest)

		d_temp <- readr::read_csv(dest, show_col_types = FALSE)

		if (length(colnames(d)) == 0) {
			d <- rbind(d, d_temp)
		}
		else {
			cols <- intersect(colnames(d), colnames(d_temp))
			d <- rbind(d[,cols], d_temp[,cols])
		}
		sys_cmd <- paste("rm", dest, sep = " ")
		system(sys_cmd)
	}

	# 2019 includes a strange extra variable called observation, removing so that output is uniform
	if ("observation" %in% colnames(d)) {
		d <- dplyr::select(d, -observation)
	}

	if (export) {
		file_prior <- paste("MPD_stop_data", year, sep = "_")
		con <- paste0(file_prior, ".csv")
		utils::write.csv(d, con)
		print(paste("Complete! File saved to", con, "in", getwd()))
	}
	else if (!export) {
		print("Complete! File in working memory, export manually to save!")
	}

	return(d)
}



