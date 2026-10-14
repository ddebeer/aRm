data(OBrienKaiser, package = "carData")
mod_mlm <- lm(cbind(pre.1, pre.2, pre.3, pre.4, pre.5,
                   post.1, post.2, post.3, post.4, post.5,
                   fup.1, fup.2, fup.3, fup.4, fup.5) ~  treatment * gender,
             data = OBrienKaiser)
mod_lm1 <- lm(pre.1 ~  treatment * gender,
              data = OBrienKaiser)

mod_lm2 <- lm(post.2 ~  treatment * gender,
              data = OBrienKaiser)

mod_lm3 <- lm(fup.3 ~  treatment * gender,
              data = OBrienKaiser)

Sigma <- sigma(mod_mlm)


test_that("diagonal of sigma for multivariate model equals sigma for univariate model", {
  expect_equal(Sigma[1, 1], sigma(mod_lm1))
  expect_equal(Sigma[7, 7], sigma(mod_lm2))
  expect_equal(Sigma[13, 13], sigma(mod_lm3))
})



test_that("sigma works", {
  expect_equal(dim(Sigma), c(15, 15))
})


test_that("sigma works for manova", {
  expect_equal(sigma(manova(mod_mlm)), Sigma)
})



test_that("sigma.mlm gives previous results", {
  expect_snapshot(Sigma)
})






