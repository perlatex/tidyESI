#' @title read top_one_percent files
#'
#' @param ... file name (named by organization name), now only support `xlsx` file format
#'
#' @return data.frame including six columns (univ, discipline, web_of_science_documents, cites, top_papers, is_enter_top_one_percent)
#' @export
#'
#' @examples
#' hc <- read_top_one_percent("filename.xlsx")
#' or
#' here::here("data") %>%
#'   fs::dir_ls(regexp = "\\.xlsx$") %>%
#'   read_top_one_percent()
#'
read_top_one_percent <- function(...) {
  arguments <- unlist(list(...))
  k <- length(arguments)
  D <- list()

  for (i in 1:k) {
    D[[i]] <-
      readxl::read_excel(arguments[i], skip = 5) %>%
      janitor::clean_names() %>%
      dplyr::filter(!is.na(research_fields)) %>%
      dplyr::filter(research_fields != "ALL FIELDS") %>%
      dplyr::mutate(discipline = stringr::str_to_title(research_fields)) %>%
      dplyr::mutate(is_enter_top_one_percent = TRUE) %>%
      dplyr::mutate(
        univ = stringr::str_split(arguments[i], "/") %>%
          unlist() %>%
          dplyr::last() %>%
          stringr::str_extract(., ".*?(?=\\.)") %>%
          stringr::str_to_title()
      ) %>%
      dplyr::select(
        univ, discipline,
        web_of_science_documents,
        cites, top_papers, is_enter_top_one_percent
      )
    
  }

  purrr::map_dfr(D, bind_rows)
}
