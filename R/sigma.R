#' Extract Sigma from multivariate models
#'
#' This function extracts estimated variance covariance matrix of the residuals (Sigma)
#' for multivariate linear models.
#'
#'
#' @param object object of class `mlm`
#' @param ... additional arguments
#'
#' @examples
#' data(OBrienKaiser, package = "carData")
#' mod_OK <- lm(cbind(pre.1, pre.2, pre.3, pre.4, pre.5,
#'                    post.1, post.2, post.3, post.4, post.5,
#'                    fup.1, fup.2, fup.3, fup.4, fup.5) ~  gender,
#'              data = OBrienKaiser)
#' Sigma <- sigma(mod_OK)
#'
#' @returns An matrix with the variances on the diagonal and the covariances of the diagonal.
#'
#'
#' @importFrom stats sigma
#' @export
sigma.mlm <- function(object,
                      ...)
{
  stats::var(object$residuals) / object$df.residual
}
