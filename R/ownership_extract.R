#' @title extract the author-ownership information of WoS plain txt
#' @description
#' Generally, a data.frame which is imported from Web of Science (WoS) plain txt will include a number of two-character field tags, i.e, column names,
#' such as `AU`, `AF`, `PY` and more. Their specific meaning are available at (https://images.webofknowledge.com/images/help/WOS/hs_wos_fieldtags.html).
#' The function of `ownership_extract()` is to extract and tidy the author-ownership information from some necessary columns.
#'
#' @param AF is a character vector about `Author Full Name`
#' @param C1 is a character vector about `Author Address`
#' @param RP is a character vector about `Reprint Address`
#'
#' @return return a tibble including five columns(.ownership, .names, .addr, .univ, .coll)
#' @export
#'
#' @examples
#'
#' res <- df %>%
#'  rowwise() %>%
#'  mutate(
#'    info = list(ownership_extract(AF, C1, RP))
#'  ) %>%
#'  ungroup()
#'
#' This code store the result in list-column. In tidyverse frame,
#' we can unnest the list-column and then get a tibble with
#' one row per ownership information * paper combination.
#'
#' res %>%
#'  select(UT, info) %>%
#'  unnest(cols = c(info)) %>%
#'  select(UT, .ownership, .names, .univ, .coll)
#'
#'
#'
ownership_extract <- function(AF, C1, RP) {

  library(tibble)
  library(stringr)
  library(dplyr)
  library(tidyr)


  if (sum(is.na(c(AF, C1, RP))) > 0) {

    result <- tibble::tibble(
      .ownership = NA_character_,
      .names     = NA_character_,
      .addr      = NA_character_,
      .univ      = NA_character_,
      .coll      = NA_character_
    )

    return(result)
    break
  }


  .data <- tibble::tibble(AF, C1, RP)

  if (!is.data.frame(.data)) {
    stop(paste(
      "The input is not a dataframe.",
      "Make sure to check it first."
    ))
  }

  if (all(c("AF", "C1", "RP") %in% colnames(.data))) {
  } else {
    stop(paste(
      "The AF, C1 and RP are not in the colnames of dataframe.",
      "Make sure to check it first."
    ))
  }


  # will return dataframe /.ownership/.names/.addr/
  tb1 <- .data %>%
    dplyr::select(AF, C1, RP) %>%
    dplyr::mutate(
      C1 = if_else(!str_detect(C1, pattern = "[\\[|\\]]"),
                   str_c("[", AF, "] ", C1),
                   C1
      )
    ) %>%
    tidyr::separate_rows(C1, sep = ";\\s+(?=\\[)", convert = TRUE) %>%
    tidyr::separate(C1,
                    into = c(".names", ".addr"),
                    sep = "(?<=\\])\\s+",
                    remove = TRUE,
                    convert = TRUE,
                    extra = "drop",
                    fill = "right"
                    ) %>%
    dplyr::mutate(.names = str_remove_all(.names, pattern = "\\[|\\]")) %>%
    tidyr::separate_rows(.names, sep = ";\\s+", convert = TRUE) %>%
    tidyr::separate(
      col = .addr,
      into = c(".univ", ".coll", ".no_use"),
      sep = ",\\s+",
      remove = FALSE,
      convert = TRUE,
      extra = "drop",
      fill = "right"
    ) %>%
    dplyr::mutate(
      .ownership = if_else(row_number() == 1, "first_author", "co_author")
    ) %>%
    dplyr::select(.ownership, .names, .addr, .univ, .coll)

  ## repair first_author has second-address
  first_author_name <- tb1 %>%
    dplyr::filter(.ownership == "first_author") %>%
    dplyr::pull(.names)

  tb1 <- tb1 %>%
    dplyr::mutate(
      .ownership = if_else(.names == first_author_name,
                           "first_author",
                           .ownership
      )
    )


  # will return dataframe /.ownership/.names/.addr/
  tb2 <- .data %>%
    dplyr::select(RP) %>%
    tidyr::separate_rows(RP, sep = "\\.;\\s+", convert = TRUE) %>%
    tidyr::separate(RP,
                    into = c(".names", ".addr"),
                    sep = "\\s+\\(.*?\\),\\s+",
                    remove = TRUE,
                    convert = TRUE,
                    extra = "drop",
                    fill = "right"
    ) %>%
    tidyr::separate_rows(.names, sep = ";\\s+", convert = TRUE) %>%
    tidyr::separate(
      col = .addr,
      into = c(".univ", ".coll", ".no_use"),
      sep = ",\\s+",
      remove = FALSE,
      convert = TRUE,
      extra = "drop",
      fill = "right"
    ) %>%
    dplyr::mutate(
      .ownership = "reprint_author"
    ) %>%
    dplyr::select(.ownership, .names, .addr, .univ, .coll)


   dplyr::bind_rows(tb1, tb2)
}
