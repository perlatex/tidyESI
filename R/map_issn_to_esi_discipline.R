#' @title map issn to ESI discipline
#'
#' @param var a column contains the ISSN of Journals
#'
#' @return data.frame that adds a new column of ESI discipline which mapped from issn
#' @export
#'
#' @examples df %>% mutate(discipline = map_issn_to_esi_discipline(issn))
map_issn_to_esi_discipline <- function(var) {

  library(dplyr)

  tb <- esi_jcr_list %>%
    dplyr::select(ISSN, discipline = `Category name`) %>%
    dplyr::mutate(discipline = stringr::str_to_title(discipline)) %>%
    #dplyr::filter(!is.na(ISSN)) %>%
    dplyr::filter(stringr::str_detect(ISSN, "\\d{4}-\\d{4}")) #%>%
    #janitor::get_dupes(ISSN)

  vector_key <- tb %>% tibble::deframe()

  dplyr::recode(var, !!!vector_key, .default = NA_character_)
}


