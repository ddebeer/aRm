#' Compute covariance matrix
#'
#' This function computes a covairance matrix based on a correlation matrix and
#' a vector of standard deviations
#'
#' @param cor a correlation matrix
#' @param sd a vector of standard deviations
#'
#' @examples
#' cor_mat <- rbind(c( 1,   0,  .3),
#'                  c( 0,   1, -.2),
#'                  c(.3, -.2,   1))
#'
#' SDs <- c(5, 10, 3)
#' cor2cov(cor_mat, sd = SDs)
#'
#' @returns a variance covariance matrix
#'
#' @export
cor2cov <- function(cor, sd){
  # for checking if the correlation matrix is a proper correlation matrix
  stopifnot("'cor' is not a matrix" = is.matrix(cor),
            "'cor' is not symmetric" = all(cor == t(cor)),
            "All diagonal values should be equal to 1." = all(diag(cor) == 1),
            "All of diagonal values should be in the -1, 1 interval" = all(cor <= 1 & cor >= -1))
  cov2cor(cor)

  # for checking sd
  dims <- dim(cor)
  stopifnot("The length of 'sd' does not correspond to the dimensions of 'cor'." = all(length(sd) == dims),
            "Some values in 'sd' are not positive" = all(sd >= 0))

  ones <- rep(1, dims[1])
  sd %o% ones * cor * ones %o% sd
}
