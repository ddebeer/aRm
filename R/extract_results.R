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
#' @examples
#' data(OBrienKaiser, package = "carData")
#' mod_OK <- lm(cbind(pre.1, pre.2, pre.3, pre.4, pre.5,
#'                    post.1, post.2, post.3, post.4, post.5,
#'                    fup.1, fup.2, fup.3, fup.4, fup.5) ~  gender,
#'              data = OBrienKaiser)
#' L <- rbind(c(1, 0))
#' M <- cbind(rep(c(-1/5, 0, 1/5), each = 5))
#' results <- extract_results(car::linearHypothesis(mod_OK, L, P = M, test = "Wilks"))
#'
#' @returns An object of class `c("anova", "data.frame")` with the test information.
#'
#' @export
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
    tests[1, 1:4] <- Pillai(eigs, x$df, x$df.residual)
  if ("Wilks" %in% test)
    tests[2, 1:4] <- Wilks(eigs, x$df, x$df.residual)
  if ("Hotelling-Lawley" %in% test)
    tests[3, 1:4] <- HL(eigs, x$df, x$df.residual)
  if ("Roy" %in% test)
    tests[4, 1:4] <- Roy(eigs, x$df, x$df.residual)
  tests <- stats::na.omit(tests)
  ok <- tests[, 2] >= 0 & tests[, 3] > 0 & tests[, 4] > 0
  ok <- !is.na(ok) & ok
  tests <- cbind(x$df, tests, stats::pf(tests[ok, 2], tests[ok, 3],
                                 tests[ok, 4], lower.tail = FALSE))
  colnames(tests) <- c("df", "test stat", "approx F", "num df",
                       "den df", "p_value")
  structure(as.data.frame(tests),
            heading = paste("\nMultivariate Test",
                            if (nrow(tests) > 1)
                              "s", ": ", x$title, sep = ""),
            class = c("anova", "data.frame"))
}




# the following functions are copies from unexported car functions with the same name
# Wilks
Wilks <- function (eig, q, df.res){
  test <- prod(1/(1 + eig))
  p <- length(eig)
  tmp1 <- df.res - 0.5 * (p - q + 1)
  tmp2 <- (p * q - 2)/4
  tmp3 <- p^2 + q^2 - 5
  tmp3 <- if (tmp3 > 0)
    sqrt(((p * q)^2 - 4)/tmp3)
  else 1
  c(test, ((test^(-1/tmp3) - 1) * (tmp1 * tmp3 - 2 * tmp2))/p/q,
    p * q, tmp1 * tmp3 - 2 * tmp2)
}

# Pillai
Pillai <- function (eig, q, df.res)
{
  test <- sum(eig/(1 + eig))
  p <- length(eig)
  s <- min(p, q)
  n <- 0.5 * (df.res - p - 1)
  m <- 0.5 * (abs(p - q) - 1)
  tmp1 <- 2 * m + s + 1
  tmp2 <- 2 * n + s + 1
  c(test, (tmp2/tmp1 * test)/(s - test), s * tmp1, s * tmp2)
}

# HL
HL <- function (eig, q, df.res)
{
  test <- sum(eig)
  p <- length(eig)
  m <- 0.5 * (abs(p - q) - 1)
  n <- 0.5 * (df.res - p - 1)
  s <- min(p, q)
  tmp1 <- 2 * m + s + 1
  tmp2 <- 2 * (s * n + 1)
  c(test, (tmp2 * test)/s/s/tmp1, s * tmp1, tmp2)
}

# Roy
Roy <- function (eig, q, df.res)
{
  p <- length(eig)
  test <- max(eig)
  tmp1 <- max(p, q)
  tmp2 <- df.res - tmp1 + q
  c(test, (tmp2 * test)/tmp1, tmp1, tmp2)
}
