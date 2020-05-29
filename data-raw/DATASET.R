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
    stringr::str_extract(., "(?<=data-raw/).*?(?=\\.xlsx)")

  readxl::read_excel(flnm, skip = 2, n_max = 22) %>%
    janitor::clean_names() %>%
    dplyr::mutate(research_fields = stringr::str_to_title(research_fields)) %>%
    dplyr::select(research_fields, {{date}} := institution)

}

Threshold_raw <- here::here("data-raw") %>%
  fs::dir_ls(regexp = "*.xlsx", recurse = FALSE) %>%
  purrr::map(~ read_esi_threshold(.)) %>%
  purrr::reduce(left_join, by = "research_fields")

#save(Threshold, file = "Threshold.Rdata")

usethis::use_data(Threshold_raw, overwrite = TRUE)

