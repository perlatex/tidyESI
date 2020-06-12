#' @title read highcited files
#'
#' @param ... file name (named by organization name), now only support `xlsx` file format
#'
#' @return data.frame including five columns (univ, discipline, year, n_paper, n_cited)
#' @export
#'
#' @examples
#' hc <- read_highcited("filename.xlsx")
#' or
#' here::here("data") %>%
#'   fs::dir_ls(regexp = "\\.xlsx$") %>%
#'   read_highcited()
#'
read_highcited <- function(...) {
  arguments <- unlist(list(...))
  k <- length(arguments)
  D <- list()

  for (i in 1:k) {
    D[[i]] <-
      readxl::read_excel(arguments[i], skip = 1) %>%
      janitor::clean_names() %>%
      dplyr::filter(stringr::str_detect(accession_number, "^WOS")) %>%
      dplyr::mutate(discipline = stringr::str_to_title(research_field)) %>%
      dplyr::mutate(times_cited = as.numeric(times_cited)) %>%
      dplyr::rename(year = publication_date)%>%
      dplyr::mutate(
        univ = stringr::str_split(arguments[i], "/") %>%
          unlist() %>%
          dplyr::last() %>%
          stringr::str_extract(., ".*?(?=\\.)")
      ) %>%
      dplyr::relocate(univ)
  }

  purrr::map_dfr(D, bind_rows)
}
