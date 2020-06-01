#' @title map addr to college name
#'
#' @param addr a column contains the addr of author
#'
#' @return data.frame
#' @export
#'
#' @examples df %>% mutate(college_name = map_addr_to_college_name(addr))
map_addr_to_college_name <- function(addr) {

  library(dplyr)

  vector_key <- raw_sicnu_collname %>% tibble::deframe()

  dplyr::recode(addr, !!!vector_key, .default = NA_character_)
}
