#' @title read Web of Science files
#'
#' @param ... file name (the files must be kept in a folder named by the retrieval organization name), now only support `txt` file format
#'
#' @return data.frame including some columns (AU, AF, SO, DE, C1, RP, FU, CR, TC, SN, PY, UT)
#' @export
#'
#' @examples
#' df <- read_wos("./Sichuan University/filename.txt")
#' # or
#' here::here("Sichuan") %>%
#'   fs::dir_ls(regexp = "\\.txt$", recurse = TRUE) %>%
#'   read_wos()
#'
#'
read_wos <- function(...) {

  library(dplyr)

  arguments <- unlist(list(...))
  k <- length(arguments)
  D <- list()

  for (i in 1:k) {
    D[[i]] <-
      readr::read_tsv(arguments[i], quote = "", col_names = TRUE) %>%
      dplyr::select(
        AU, AF, SO, DE, C1, RP, FU, CR, TC, SN, PY, UT
      ) %>%
      dplyr::mutate(
        univ = stringr::str_split(arguments[i], "/", simplify = F) %>%
               purrr::map_chr(., ~.x[length(.x) - 1]) %>%
               stringr::str_to_title()
      ) %>%
      dplyr::relocate(univ)
  }

  purrr::map_dfr(D, bind_rows)

}





