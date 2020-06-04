
# tidyESI

<!-- badges: start -->
<!-- badges: end -->

The goal of `tidyESI` is to make discipline statistics more easy and more tidyverse.

## Installation

You can install the development version of `tidyESI` with:

``` r
devtools::install_github("perlatex/tidyESI")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(tidyESI)
esi_discipline
```


``` r
library(tidyverse)

dt <- tibble(x = c("Agricultural Sciences", "Chemistry"))
dt
dt %>% add_esi_threshold(x)
dt %>% add_esi_threshold(x, date = "all")
dt %>% add_esi_threshold(x, date = "ALL")
dt %>% add_esi_threshold(x, date = c("20200326"))
dt %>% add_esi_threshold(x, date = c("20200326", "20200514"))
```

``` r
dt %>% add_high_cited(x, scope = "last year")
dt %>% add_high_cited(x, scope = "each year")
dt %>% add_high_cited(x, scope = "all year")
```
