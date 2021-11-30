get_all_data <- function(export = F) {
	d <- metropdcleanR::get_yr_data(year = 2019:2021, export = export)

	return(d)
}
