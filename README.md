
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aRm

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/ddebeer/aRm/graph/badge.svg)](https://app.codecov.io/gh/ddebeer/aRm)
[![R-CMD-check](https://github.com/ddebeer/aRm/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ddebeer/aRm/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/aRm)](https://CRAN.R-project.org/package=aRm)
<!-- badges: end -->

The aRm packages provides helpful functions related to the course
Analysis of Repeated Measurements

## Installation

You can install the development version of aRm from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("ddebeer/aRm")
```

## Example - Linear Hypothesis

This is a basic example which shows how to use the `extract_results()`
function.

``` r
library(aRm)
```

For this example, let’s load the OBrienKaiser data. The data set
includes 15 repeated measures:

- five pre measures
- five post measures
- five follow-up measures

``` r
data(OBrienKaiser, package = "carData")
```

For more information about the data set, you can consult the
documentation.

``` r
?carData::OBrienKaiser
```

A multi-variate linear model is fit to the data.

``` r
mod_OK <- lm(cbind(pre.1, pre.2, pre.3, pre.4, pre.5,
                   post.1, post.2, post.3, post.4, post.5,
                   fup.1, fup.2, fup.3, fup.4, fup.5) ~  treatment * gender,
             data = OBrienKaiser)
```

To test a specific hypothesis, an L- and M-Matrix can be specified. Here
the null hypothesis is: “*on average, there is no difference between the
pre and the follow-up measures*”. Considering the contrasts for
`treatment` and `gender`, the corresponding L-matrix is:

``` r
L <- rbind(c(1, 0, 0, 0, 0, 0))
dimnames(L) <- list("average", rownames(coef(mod_OK)))
knitr::kable(L)
```

|  | (Intercept) | treatment1 | treatment2 | gender1 | treatment1:gender1 | treatment2:gender1 |
|:---|---:|---:|---:|---:|---:|---:|
| average | 1 | 0 | 0 | 0 | 0 | 0 |

The M-matrix can be defined as follows:

``` r
M <- cbind(rep(c(-1/5, 0, 1/5), each = 5))
dimnames(M) <- list(colnames(coef(mod_OK)), "fu-pre")
knitr::kable(M)
```

|        | fu-pre |
|:-------|-------:|
| pre.1  |   -0.2 |
| pre.2  |   -0.2 |
| pre.3  |   -0.2 |
| pre.4  |   -0.2 |
| pre.5  |   -0.2 |
| post.1 |    0.0 |
| post.2 |    0.0 |
| post.3 |    0.0 |
| post.4 |    0.0 |
| post.5 |    0.0 |
| fup.1  |    0.2 |
| fup.2  |    0.2 |
| fup.3  |    0.2 |
| fup.4  |    0.2 |
| fup.5  |    0.2 |

The `linearHypothesis()` function from the `car` package prints the test
results, but the returned object does not contain the printed values.
Yet, invisible a `linearHypothesis.mlm` object is returned.

``` r
test <- car::linearHypothesis(mod_OK, L, P = M, test = "Wilks")
test
#> 
#>  Response transformation matrix:
#>        fu-pre
#> pre.1    -0.2
#> pre.2    -0.2
#> pre.3    -0.2
#> pre.4    -0.2
#> pre.5    -0.2
#> post.1    0.0
#> post.2    0.0
#> post.3    0.0
#> post.4    0.0
#> post.5    0.0
#> fup.1     0.2
#> fup.2     0.2
#> fup.3     0.2
#> fup.4     0.2
#> fup.5     0.2
#> 
#> Sum of squares and products for the hypothesis:
#>          fu-pre
#> fu-pre 49.31322
#> 
#> Sum of squares and products for error:
#>          fu-pre
#> fu-pre 12.41667
#> 
#> Multivariate Test: 
#>       Df test stat approx F num Df den Df     Pr(>F)    
#> Wilks  1 0.2011451 39.71534      1     10 8.8853e-05 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

In order to extract the test results, the `extract_results()` function
from the `aRm` package can be used:

``` r
results <- extract_results(test)
knitr::kable(results, digits = c(1, 3, 1, 0, 0, 5))
```

|       |  df | test stat | approx F | num df | den df | p_value |
|:------|----:|----------:|---------:|-------:|-------:|--------:|
| Wilks |   1 |     0.201 |     39.7 |      1 |     10 |   9e-05 |

As the returned object is a `data.frame`, extracting results is
straightforward.

``` r
p <- results$'p-value'
```

## Example - Anova

It is also possible to specify the design of the repeated measures:

``` r
idata <- expand.grid(measure = factor(1:5), 
                     time = factor(c("pre", "post", "fup")))
contrasts(idata$measure) <- contr.sum(5)
contrasts(idata$time) <- contr.sum(3)

anova <- car::Anova(mod_OK, 
                    idata = idata, 
                    idesign = ~ measure * time, 
                    type = "III")
```

In order to extract the test results, the `extract_results()` function
from the `aRm` package can be used:

``` r
results <- extract_results(anova)
knitr::kable(results, digits = c(1, 3, 1, 0, 0, 5))
```

|                               |  df | test stat | approx F | num df | den df | p_value |
|:------------------------------|----:|----------:|---------:|-------:|-------:|--------:|
| (Intercept)                   |   1 |     0.967 |    296.4 |      1 |     10 | 0.00000 |
| treatment                     |   2 |     0.441 |      3.9 |      2 |     10 | 0.05471 |
| gender                        |   1 |     0.268 |      3.7 |      1 |     10 | 0.08480 |
| treatment:gender              |   2 |     0.364 |      2.9 |      2 |     10 | 0.10447 |
| measure                       |   1 |     0.933 |     24.3 |      4 |      7 | 0.00033 |
| treatment:measure             |   2 |     0.316 |      0.4 |      8 |     16 | 0.91833 |
| gender:measure                |   1 |     0.339 |      0.9 |      4 |      7 | 0.51298 |
| treatment:gender:measure      |   2 |     0.570 |      0.8 |      8 |     16 | 0.61319 |
| time                          |   1 |     0.814 |     19.6 |      2 |      9 | 0.00052 |
| treatment:time                |   2 |     0.696 |      2.7 |      4 |     20 | 0.06211 |
| gender:time                   |   1 |     0.066 |      0.3 |      2 |      9 | 0.73497 |
| treatment:gender:time         |   2 |     0.311 |      0.9 |      4 |     20 | 0.47215 |
| measure:time                  |   1 |     0.560 |      0.5 |      8 |      3 | 0.82027 |
| treatment:measure:time        |   2 |     0.662 |      0.2 |     16 |      8 | 0.99155 |
| gender:measure:time           |   1 |     0.712 |      0.9 |      8 |      3 | 0.58949 |
| treatment:gender:measure:time |   2 |     0.793 |      0.3 |     16 |      8 | 0.97237 |
