#' @title add new column for university name in chinese
#'
#' @param df data.frame
#' @param var column name for university name in english
#'
#' @return data.frame that adds a new column of university name in chinese
#' @export
#'
#' @examples df %>% add_univ_name_cn(univ)
add_univ_name_cn <- function(df, var) {
  library(dplyr)
  tb <- tibble::tribble(
    ~univ, ~school,
    "Beijing Normal University", "北京师范大学",
    "East China Normal University", "华东师范大学",
    "Central China Normal University", "华中师范大学",
    "Nanjing Normal University", "南京师范大学",
    "Hunan Normal University", "湖南师范大学",
    "Northeast Normal University", "东北师范大学",
    "South China Normal University", "华南师范大学",
    "Shaanxi Normal University", "陕西师范大学",
    "Capital Normal University", "首都师范大学",
    "Zhejiang Normal University", "浙江师范大学",
    "Shandong Normal University", "山东师范大学",
    "Tianjin Normal University", "天津师范大学",
    "Fujian Normal University", "福建师范大学",
    "Henan Normal University", "河南师范大学",
    "Jiangxi Normal University", "江西师范大学",
    "Shanghai Normal University", "上海师范大学",
    "Anhui Normal University", "安徽师范大学",
    "Northwest Normal University", "西北师范大学",
    "Guangxi Normal University", "广西师范大学",
    "Hangzhou Normal University", "杭州师范大学",
    "Yunnan Normal University", "云南师范大学",
    "Harbin Normal University", "哈尔滨师范大学",
    "Hebei Normal University", "河北师范大学",
    "Jiangsu Normal University", "江苏师范大学",
    "Sichuan Normal University", "四川师范大学",
    "Liaoning Normal University", "辽宁师范大学",
    "Chongqing Normal University", "重庆师范大学",
    "Qufu Normal University", "曲阜师范大学",
    "Guizhou Normal University", "贵州师范大学",
    "Hainan Normal University", "海南师范大学"
  )


  notwithin <-
    df %>%
    mutate(
      is_within_univ = if_else({{var}} %in% tb$univ, TRUE, FALSE)
    ) %>%
    summarise(num = sum(!is_within_univ)) %>%
    pull(num)

  message(
    glue::glue("there are {notwithin} row have no alternative.")
  )
  # Use a named character vector for unquote splicing with !!!
  # https://dplyr.tidyverse.org/reference/recode.html
  vector_key <- tb %>% tibble::deframe()


  df %>% mutate(
    "{{var}}_cn" := dplyr::recode({{var}}, !!!vector_key, .default = NA_character_)
  )
}




