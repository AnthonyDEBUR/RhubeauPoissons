---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# RhubeauPoissons

<!-- badges: start -->
[![R-CMD-check](https://github.com/AnthonyDEBUR/RhubeauPoissons/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/AnthonyDEBUR/RhubeauPoissons/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/AnthonyDEBUR/RhubeauPoissons/branch/master/graph/badge.svg)](https://app.codecov.io/gh/AnthonyDEBUR/RhubeauPoissons?branch=master)
<!-- badges: end -->

The goal of RhubeauPoissons is to ...

## Installation

You can install the development version of RhubeauPoissons from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("AnthonyDEBUR/RhubeauPoissons")
```

## Documentation

Full documentation website on: https://AnthonyDEBUR.github.io/RhubeauPoissons

## Example

This is a basic example which shows you how to solve a common problem:


``` r
library(RhubeauPoissons)
#> Error in library(RhubeauPoissons): aucun package nommé 'RhubeauPoissons' n'est trouvé
```

``` r
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so:


``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<div class="figure">
<img src="man/figures/README-pressure-1.png" alt="plot of chunk pressure" width="100%" />
<p class="caption">plot of chunk pressure</p>
</div>

In that case, don't forget to commit and push the resulting figure files, so they display on GitHub and CRAN.
