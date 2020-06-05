#' @title read incites file
#'
#' @param flnm file name, only only support `csv` file format
#'
#' @return data.frame including four columns (discipline, year, n_paper, n_cited)
#' @export
#'
#' @examples
#' df <- read_incites("filename.csv")
#'
read_incites <- function(flnm) {
  readr::read_csv(flnm) %>%
    dplyr::select(
      discipline = "名称",
      year = "出版年",
      n_paper = "Web of Science 论文数",
      n_cited = "被引频次"
    ) %>%
    dplyr::filter(!is.na(year)) %>%
    dplyr::mutate(year = as.character(year)) %>%
    dplyr::mutate(discipline = stringr::str_to_title(discipline))
}
