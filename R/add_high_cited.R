#' @title add high-cited information for ESI discipline
#'
#' @param df  data.frame
#' @param discipline  a column containing the character vector of 22 ESI disciplines
#' @param source  a data.frame imported by `read_highcited()`
#' @param scope   can be one of `last year`, `all year` and `each year`
#'
#' @return data.frame that adds some new column about high-cited information for the specified discipline.
#' @export
#'
#' @examples
#' df %>% add_high_cited(x, source = hc, scope = "last year")
#' df %>% add_high_cited(x, source = hc, scope = "each year")
#' df %>% add_high_cited(x, source = hc, scope = "all year")
add_high_cited <- function(df,
                           discipline,
                           source = NULL,
                           scope = "each year") {
  library(dplyr)
  library(rlang)

  if(!is.data.frame(source))
    stop("Wrong Arguments 'source', please specify a data.frame imported by `read_highcited()`")



  join_var <- as_name(enquo(discipline))
  raw_highcited_timeserial <- source

  if (scope == "last year") {
    subset <- raw_highcited_timeserial %>%
      dplyr::group_by(discipline, year) %>%
      dplyr::summarise(
        n_paper_high = n(),
        n_cited_high = sum(times_cited),
        .groups = "drop"
      ) %>%
      filter(year == max(year)) %>%
      select(-year)
  } else if (scope == "each year") {
    subset <- raw_highcited_timeserial %>%
      dplyr::group_by(discipline, year) %>%
      dplyr::summarise(
        n_paper_high = n(),
        n_cited_high = sum(times_cited),
        .groups = "drop"
      )
  } else if (scope == "all year") {
    subset <- raw_highcited_timeserial %>%
      dplyr::group_by(discipline) %>%
      dplyr::summarise(
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
    dplyr::select(!!join_var := discipline, everything())

  if (scope == "each year" & "year" %in% colnames(df)) {
      df %>%
        dplyr::left_join(subset, by = c("univ", {{join_var}}, "year"))
  } else {
      df %>%
        dplyr::left_join(subset, by = c("univ", {{join_var}}))
  }

}
