

as_tbl_esi <- function(.data){

  if (all(c("univ", "discipline", "year_range") %in% colnames(.data))) {
    attr(.data, "df_type") <- "year_summary"
  } else if (all(c("univ", "discipline", "year") %in% colnames(.data))) {
    attr(.data, "df_type") <- "each_title"
  } else {
    stop_glue("`as_tbl_esl` at least need three variables:
              univ, discipline and year or year_range")
  }

  .data

}



# attrs_check <- function(.data) {
#   attrs <- c("each_title", "each_year", "ten_year")
#   attr(.data, "type") %in% attrs
# }


check_title_attrs <- function(.data) {
  attrs <- c("each_title")
  attr(.data, "df_type") %in% attrs
}



glue_null <- function(..., .sep = "") {
  glue::glue(
    ..., .sep = .sep
  )
}


stop_glue <- function(..., .sep = "") {
  stop(
    glue_null(..., .sep = .sep)
  )
}

warning_glue <- function(..., .sep = "") {
  warning(
    glue_null(..., .sep = .sep)
  )
}

message_glue <- function(..., .sep = "") {
  message(
    glue_null(..., .sep = .sep)
  )
}



#' @title obtain the range of vector
#'
#' @param x vector
#'
#' @return   if `min(x) == max(x)`, will return `range(x)[1]`, else return character `range(x)[1] - range(x)[2]`
#' @export
#'
#' @examples custom_range(x)
custom_range <- function(x) {
  rng <- range(x)

  if (rng[1] == rng[2]) {
    stringr::str_c(rng[1])
  } else {
    stringr::str_c(rng[1], "-", rng[2])
  }
}


