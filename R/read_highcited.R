#' @title read highcited file
#'
#' @param flnm file name, only only support `xlsx` file format
#'
#' @return data.frame including four columns (discipline, year, n_paper, n_cited)
#' @export
#'
#' @examples
#' hc <- read_highcited("filename.xlsx")
#'
read_highcited <- function(flnm) {
  raw_highcited_timeserial <-
    readxl::read_excel(flnm, skip = 1) %>%
    janitor::clean_names() %>%
    dplyr::filter(stringr::str_detect(accession_number, "^WOS")) %>%
    dplyr::mutate(discipline = stringr::str_to_title(research_field)) %>%
    dplyr::mutate(times_cited = as.numeric(times_cited)) %>%
    dplyr::rename(
      #discipline,
      year = publication_date#,
      #times_cited
    )
  raw_highcited_timeserial
}
