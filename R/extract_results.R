#' Extract results
#'
#' This function extracts the test results from linear hypothesis tests
#' on multivariate linear models as returned by the `car` package
#'
#' This function is a copy of the S3 `print()` method for objects of the
#' `linearHypothesis.mlm`-class. However, rather than invisibly returning
#' the object, the printed test results are returned as a data.frame
#'
#' @param x object of class `linearHypothesis.mlm` or class `Anova.mlm`
#' @param test the type of multivariate test to extract. Should be `NULL`, the default, or one of
#'             "Pillai", "Wilks", "Hotelling-Lawley", "Roy".
#' @param ... additional arguments
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
extract_results <- function(x, test = NULL, ...)
  UseMethod("extract_results")


#' @exportS3Method
extract_results.Anova.mlm <- function(x,
                                      test = NULL,
                                      ...)
{
  if ((!is.null(x$singular)) && any(x$singular))
    stop("singular error SSP matrix; multivariate tests unavailable\ntry summary(object, multivariate=FALSE)")
  if(is.null(test)) test <- x$test
  stopifnot("The `test` should be one of 'Pillai', 'Wilks', 'Hotelling-Lawley', and 'Roy'" = sum(test %in% c("Pillai", "Wilks", "Hotelling-Lawley", "Roy")) == 1)
  repeated <- x$repeated
  nterms <- length(x$terms)
  out <- matrix(NA, nterms, 4)
  if (!repeated)
    SSPE.qr <- qr(x$SSPE)
  for (term in seq_len(nterms)) {
    eigs <- Re(eigen(qr.coef(if (repeated) qr(x$SSPE[[term]]) else SSPE.qr,
                             x$SSP[[term]]), symmetric = FALSE)$values)

    if ("Pillai" == test)
      out[term, 1:4] <- Pillai(eigs, x$df[term], x$error.df)
    if ("Wilks" == test)
      out[term, 1:4] <- Wilks(eigs, x$df[term], x$error.df)
    if ("Hotelling-Lawley" == test)
      out[term, 1:4] <- HL(eigs, x$df[term], x$error.df)
    if ("Roy" == test)
      out[term, 1:4] <- Roy(eigs, x$df[term], x$error.df)
  }

  out <- cbind(x$df, out, stats::pf(out[, 2], out[, 3],
                                 out[, 4], lower.tail = FALSE))
  rownames(out) <- x$terms
  colnames(out) <- c("df", "test stat", "approx F", "num df",
                     "den df", "p_value")
  structure(as.data.frame(out),
            heading = paste("\nType ",
                            x$type, if (repeated)
                              " Repeated Measures", " MANOVA Tests: ",
                            test, " test statistic",
                            sep = ""),
            class = c("anova", "data.frame"))

}


#' @exportS3Method
extract_results.linearHypothesis.mlm <- function(x,
                                                 test = NULL,
                                                 ...)
{
  if(is.null(test)) test <- x$test
  stopifnot("The `test` should be one or more of 'Pillai', 'Wilks', 'Hotelling-Lawley', and 'Roy'" = all(test %in% c("Pillai", "Wilks", "Hotelling-Lawley", "Roy")))


  if ((!is.null(x$singular)) && x$singular) {
    warning("the error SSP matrix is singular; multivariate tests are unavailable")
    return(invisible(x))
  }
  SSPE.qr <- qr(x$SSPE)
  eigs <- Re(eigen(qr.coef(SSPE.qr, x$SSPH), symmetric = FALSE)$values)
  out <- matrix(NA, 4, 4)
  rownames(out) <- c("Pillai", "Wilks", "Hotelling-Lawley",
                       "Roy")
  if ("Pillai" %in% test)
    out[1, 1:4] <- Pillai(eigs, x$df, x$df.residual)
  if ("Wilks" %in% test)
    out[2, 1:4] <- Wilks(eigs, x$df, x$df.residual)
  if ("Hotelling-Lawley" %in% test)
    out[3, 1:4] <- HL(eigs, x$df, x$df.residual)
  if ("Roy" %in% test)
    out[4, 1:4] <- Roy(eigs, x$df, x$df.residual)
  out <- stats::na.omit(out)
  ok <- out[, 2] >= 0 & out[, 3] > 0 & out[, 4] > 0
  ok <- !is.na(ok) & ok
  out <- cbind(x$df, out, stats::pf(out[ok, 2], out[ok, 3],
                                 out[ok, 4], lower.tail = FALSE))
  colnames(out) <- c("df", "test stat", "approx F", "num df",
                       "den df", "p_value")
  structure(as.data.frame(out),
            heading = paste("\nMultivariate Test",
                            if (nrow(out) > 1)
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
