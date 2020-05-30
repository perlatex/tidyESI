#' @title add threshold value for each ESI discipline
#'
#' @param df   data.frame
#' @param discipline  a column belong to the character vector of 22 ESI disciplines
#' @param date  the date when the threshold line was published, can be `date = "last"`, `date = "all"` or the specified `date = c("20200326")`
#'
#' @return data.frame that adds a new column of threshold line for the specified date
#' @export
#'
#' @examples
#' df %>% add_esi_threshold(x, date = "last")
#' df %>% add_esi_threshold(x, date = "all")
#' df %>% add_esi_threshold(x, date = c("20200326"))
add_esi_threshold <- function(df, discipline, date = "last") {
  library(dplyr)
  library(rlang)

  join_var <- as_name(enquo(discipline))


  if (date == "last") {
    Threshold_subset <- Threshold_raw %>%
      dplyr::select(!!join_var := research_fields, last_col())
  } else if (date %in% c("all", "ALL")) {
    Threshold_subset <- Threshold_raw %>%
      dplyr::select(!!join_var := research_fields, everything())
  } else if (all(date %in% colnames(Threshold_raw)[-1])) {
    Threshold_subset <- Threshold_raw %>%
      dplyr::select(!!join_var := research_fields, any_of(date))
  } else {
    abort(
      glue::glue("Wrong date type: only 'last', 'all' and {colnames(Threshold_raw)[-1]} are supported")
    )
  }


  notwithin <- df %>%
    mutate(
      is_within_discipline = if_else({{discipline}} %in% Threshold_subset[[join_var]], TRUE, FALSE)
    ) %>%
    summarise(num = sum(!is_within_discipline)) %>%
    pull(num)

  message(
    glue::glue("there are {notwithin} row have no alternative.")
  )



  df %>%
    dplyr::left_join(Threshold_subset, by = setNames(join_var, join_var))
}
