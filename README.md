
# tidyESI

<!-- badges: start -->
<!-- badges: end -->
ESI [(Essential Science Indicators)](https://esi.clarivate.com/) is widely used in the evaluation of scientific research competitiveness. The goal of `tidyESI` is to make discipline statistics more easy and more tidyverse.

## Installation

You can install the development version of `tidyESI` with:

``` r
devtools::install_github("perlatex/tidyESI")
```
## How to use

[There](https://github.com/perlatex/tidyESI/tree/master/vignettes) are manuals and documents here, but only Chinese at present.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(tidyESI)
esi_discipline
```

### add_esi_threshold
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
esi_discipline %>% add_esi_threshold(discipline, date = "last")
esi_discipline %>% add_esi_threshold(discipline, date = "all")
```

### add_high_cited
``` r
sicnu <- read_highcited(here::here("data", "highly20200514.xlsx"))
sicnu
```


``` r
df <- tibble(
  u = "Sichuan Normal University",
  d = c("Chemistry")
)
```


``` r
df %>%
  add_high_cited(u, d, source = sicnu, scope = "all year")
```
