#' @title add high-cited information for ESI discipline
#'
#' @param .data  data.frame
#' @param univ  a column containing the university name
#' @param discipline  a column containing the character vector of 22 ESI disciplines
#' @param source  a data.frame imported by `read_highcited()`
#' @param scope   can be one of `last year`, `all year` and `each year`
#'
#' @return data.frame that adds some new column about high-cited information for the specified discipline.
#' @export
#'
#' @examples
#' df %>% add_high_cited(univ, discipline, source = hc, scope = "last year")
#' df %>% add_high_cited(univ, discipline, source = hc, scope = "each year")
#' df %>% add_high_cited(univ, discipline, source = hc, scope = "all year")
add_high_cited <- function(.data,
                           univ,
                           discipline,
                           source = NULL,
                           scope = "each year") {
  library(dplyr)
  library(rlang)

  # if (!all(c("univ", "discipline") %in% colnames(.data))) {
  #   stop_glue(
  #     "`.data` at least need two variables: univ, discipline"
  #   )
  # }

  if(!is.data.frame(source)){
    stop_glue(
      "Wrong Arguments 'source', please specify a data.frame imported by `read_highcited()`"
      )
  }

  if (!check_title_attrs(source)) {
    stop_glue(
      "please specify 'source' imported by `read_highcited()`"
    )
  }

  univ_var <- as_name(enquo(univ))
  disc_var <- as_name(enquo(discipline))

  raw_highcited_timeserial <- source %>%
    dplyr::mutate(univ = stringr::str_to_title(univ))

  if (scope == "last year") {
    subset <- raw_highcited_timeserial %>%
      dplyr::group_by(univ, discipline, year) %>%
      dplyr::summarise(
        n_paper_high = n(),
        n_cited_high = sum(times_cited),
        .groups = "drop"
      ) %>%
      dplyr::filter(year == max(year)) %>%
      dplyr::rename(year_range = year)
  } else if (scope == "each year") {
    subset <- raw_highcited_timeserial %>%
      dplyr::group_by(univ, discipline, year) %>%
      dplyr::summarise(
        n_paper_high = n(),
        n_cited_high = sum(times_cited),
        .groups = "drop"
      ) %>%
      dplyr::rename(year_range = year)
  } else if (scope == "all year") {
    subset <- raw_highcited_timeserial %>%
      dplyr::group_by(univ, discipline) %>%
      dplyr::summarise(
        year_range = custom_range(year),
        n_paper_high = n(),
        n_cited_high = sum(times_cited),
        .groups = "drop"
      )
  } else {
    abort(
      glue::glue("wrong scope: only 'each year', 'last year' and 'all year' are supported")
    )
  }

  subset <- subset %>%
    dplyr::mutate(year_range = as.character(year_range)) %>%
    dplyr::select(!!univ_var := univ, !!disc_var := discipline, year_range, everything())


if (!"year_range" %in% colnames(.data)) {
  .data %>%
    dplyr::left_join(subset, by = c({{univ_var}}, {{disc_var}}))
} else if (scope %in% c("last year", "all year")) {
  warning_glue("Two data.frame maybe have different year_range, Are you sure you want this?")
  .data %>%
    dplyr::select(-year_range) %>%
    dplyr::left_join(subset, by = c({{univ_var}}, {{disc_var}}))
} else {
  .data %>%
    dplyr::left_join(subset, by = c({{univ_var}}, {{disc_var}}, "year_range"))
}


  # if (scope == "each year" & "year_range" %in% colnames(.data)) {
  #     .data %>%
  #       dplyr::left_join(subset, by = c({{univ_var}}, {{disc_var}}, "year_range"))
  # } else {
  #     .data %>%
  #       dplyr::left_join(subset, by = c({{univ_var}}, {{disc_var}}))
  # }

}


