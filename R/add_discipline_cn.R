#' @title add new column for ESI discipline in chinese
#'
#' @param df data.frame
#' @param var column name for ESI discipline
#'
#' @return data.frame that adds a new column of ESI discipline in chinese
#' @export
#'
#' @examples df %>% add_discipline_cn(discipline)
add_discipline_cn <- function(df, var) {
  library(dplyr)
  tb <- tibble::tribble(
    ~discipline, ~discipline_cn,
    "Computer Science", "计算机科学",
    "Engineering", "工程学",
    "Materials Science", "材料科学",
    "Biology & Biochemistry", "生物学与生物化学",
    "Environment/Ecology", "环境科学与生态学",
    "Microbiology", "微生物学",
    "Molecular Biology & Genetics", "分子生物学与遗传学",
    "Social Sciences, General", "社会科学总论",
    "Social Sciences, general", "社会科学总论",
    "Economics & Business", "经济与商业",
    "Chemistry", "化学",
    "Geosciences", "地球科学",
    "Mathematics", "数学",
    "Physics", "物理学",
    "Space Science", "空间科学",
    "Agricultural Sciences", "农业科学",
    "Plant & Animal Science", "植物学与动物学",
    "Clinical Medicine", "临床医学",
    "Immunology", "免疫学",
    "Neuroscience & Behavior", "神经系统学与行为学",
    "Pharmacology & Toxicology", "药理学和毒理学",
    "Psychiatry/Psychology", "精神病学与心理学",
    "Multidisciplinary", "综合交叉学科"
  )


  notwithin <-
    df %>%
    mutate(
      is_within_discipline = if_else({{var}} %in% tb$discipline, TRUE, FALSE)
    ) %>%
    # filter(!is_within_discipline)
    summarise(num = sum(!is_within_discipline)) %>%
    pull(num)

  message(
    glue::glue("there are {notwithin} row have no alternative.")
  )
  # Use a named character vector for unquote splicing with !!!
  # https://dplyr.tidyverse.org/reference/recode.html
  vector_key <- tb %>% tibble::deframe()


  df %>% mutate(
    "{{var}}_cn" := dplyr::recode({{var}}, !!!vector_key)
  )
}





