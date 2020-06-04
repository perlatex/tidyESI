#' @title add high-cited information for ESI discipline
#'
#' @param df   data.frame, but only support dataset about `Sichuan Normal University` now.
#' @param discipline  a column belong to the character vector of 22 ESI disciplines
#' @param scope   can be one of `last year`, `all year` and `each year`
#'
#' @return data.frame that adds some new column about high-cited information for the specified discipline.
#' @export
#'
#' @examples
#' df %>% add_high_cited(x, scope = "last year")
#' df %>% add_high_cited(x, scope = "each year")
#' df %>% add_high_cited(x, scope = "all year")
add_high_cited <- function(df,
                           discipline,
                           univ = "Sichuan Normal University", # not used now
                           scope = "each year") {
  library(dplyr)
  library(rlang)

  join_var <- as_name(enquo(discipline))


  if (scope == "last year") {
    subset <- raw_highcited_timeserial %>%
      dplyr::group_by(discipline, year) %>%
      dplyr::summarise(
        n_paper_high = n(),
        n_cited_high = sum(times_cited),
        .groups = "drop"
      ) %>%
      filter(year == max(year))
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

  if (scope == "each year") {
      df %>%
        dplyr::left_join(subset, by = c({{join_var}}, "year"))
  } else {
      df %>%
        dplyr::left_join(subset, by = {{join_var}})
  }

}
