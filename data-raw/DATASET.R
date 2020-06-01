## code to prepare `DATASET` dataset goes here


library(tidyverse)

esi_discipline <- tibble::tribble(
  ~discipline,
  "Computer Science",
  "Engineering",
  "Materials Science",
  "Biology & Biochemistry",
  "Environment/Ecology",
  "Microbiology",
  "Molecular Biology & Genetics",
  "Social Sciences, General",
  "Economics & Business",
  "Chemistry",
  "Geosciences",
  "Mathematics",
  "Physics",
  "Space Science",
  "Agricultural Sciences",
  "Plant & Animal Science",
  "Clinical Medicine",
  "Immunology",
  "Neuroscience & Behavior",
  "Pharmacology & Toxicology",
  "Psychiatry/Psychology",
  "Multidisciplinary"
)

usethis::use_data(esi_discipline, overwrite = TRUE)



read_esi_threshold <- function(flnm) {

  date <- flnm %>%
    stringr::str_extract(., "(?<=raw_Threshold/).*?(?=\\.xlsx)")

  readxl::read_excel(flnm, skip = 2, n_max = 22) %>%
    janitor::clean_names() %>%
    dplyr::mutate(research_fields = stringr::str_to_title(research_fields)) %>%
    dplyr::select(research_fields, {{date}} := institution)

}

Threshold_raw <- here::here("data-raw", "raw_Threshold") %>%
  fs::dir_ls(regexp = "*.xlsx", recurse = FALSE) %>%
  purrr::map(~ read_esi_threshold(.)) %>%
  purrr::reduce(left_join, by = "research_fields")

usethis::use_data(Threshold_raw, overwrite = TRUE)




esi_jcr_list <- readxl::read_excel(
  here::here("data-raw", "raw_esi_jcr_list", "esi-master-journal-list-5-2020.xlsx")
)
usethis::use_data(esi_jcr_list, overwrite = TRUE)



raw_sicnu_collname <- readxl::read_excel(
  here::here("data-raw", "raw_college_name", "sicnu_coll_name_en2cn.xlsx")
)
usethis::use_data(raw_sicnu_collname, overwrite = TRUE)





