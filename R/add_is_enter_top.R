#' @title add is_enter_top_one_percent information for ESI discipline of university
#'
#' @param df  data.frame
#' @param univ  a column containing the university name
#' @param discipline  a column containing the character vector of 22 ESI disciplines
#' @param source  a data.frame imported by `read_top_one_percent()`
#' @param .keep  The default value is `FALSE`, only `is_enter_top_one_percent` will be added. When `.keep = TRUE`, more information will be added.
#'
#' @return data.frame that adds `is_enter_top_one_percent` information for the specified discipline of university.
#' @export
#'
#' @examples
#' df %>% add_is_enter_top(univ, discipline, source = top)
add_is_enter_top <- function(df,
                             univ,
                             discipline,
                             source = NULL,
                             .keep = FALSE
                             ) {
  library(dplyr)
  library(rlang)

  cat("Please make sure the source information is up to date.")

  if(!is.data.frame(source))
    stop("Wrong Arguments 'source', please specify a data.frame imported by `read_top_one_percent()`")


  univ_var <- as_name(enquo(univ))
  disc_var <- as_name(enquo(discipline))


  if (isTRUE(.keep)) {
    subset <- raw_top_one_percent %>%
      dplyr::select(!!univ_var := univ, !!disc_var := discipline, everything())
  } else{
    subset <- raw_top_one_percent %>%
      dplyr::select(!!univ_var := univ, !!disc_var := discipline, is_enter_top_one_percent)
  }

  df %>% dplyr::left_join(subset, by = c({{univ_var}}, {{disc_var}}))

}
