#' Extract results
#'
#' This function extracts the test results from linear hypothesis tests
#' on multivariate linear models as returned by the `car` package
#'
#' This function is a copy of the S3 `print()` method for objects of the
#' `linearHypothesis.mlm`-class. However, rather than invisibly returning
#' the object, the printed test results are returned as a data.frame
#'
#' @param x object of class `linearHypothesis.mlm`
#'
#' @returns An object of class `c("anova", "data.frame")` with the test information.
extract_results <- function(x)
{
  # test if object is of correct class
  stopifnot("'x' should be of class 'linearHypothesis.mlm'." = inherits(x, what = "linearHypothesis.mlm"))
  test <- x$test

  if ((!is.null(x$singular)) && x$singular) {
    warning("the error SSP matrix is singular; multivariate tests are unavailable")
    return(invisible(x))
  }
  SSPE.qr <- qr(x$SSPE)
  eigs <- Re(eigen(qr.coef(SSPE.qr, x$SSPH), symmetric = FALSE)$values)
  tests <- matrix(NA, 4, 4)
  rownames(tests) <- c("Pillai", "Wilks", "Hotelling-Lawley",
                       "Roy")
  if ("Pillai" %in% test)
    tests[1, 1:4] <- car:::Pillai(eigs, x$df, x$df.residual)
  if ("Wilks" %in% test)
    tests[2, 1:4] <- car:::Wilks(eigs, x$df, x$df.residual)
  if ("Hotelling-Lawley" %in% test)
    tests[3, 1:4] <- car:::HL(eigs, x$df, x$df.residual)
  if ("Roy" %in% test)
    tests[4, 1:4] <- car:::Roy(eigs, x$df, x$df.residual)
  tests <- na.omit(tests)
  ok <- tests[, 2] >= 0 & tests[, 3] > 0 & tests[, 4] > 0
  ok <- !is.na(ok) & ok
  tests <- cbind(x$df, tests, pf(tests[ok, 2], tests[ok, 3],
                                 tests[ok, 4], lower.tail = FALSE))
  colnames(tests) <- c("df", "test stat", "approx F", "num df",
                       "den df", "p-value")
  structure(as.data.frame(tests),
            heading = paste("\nMultivariate Test",
                            if (nrow(tests) > 1)
                              "s", ": ", x$title, sep = ""),
            class = c("anova", "data.frame"))
}





