data(OBrienKaiser, package = "carData")
mod_OK <- lm(cbind(pre.1, pre.2, pre.3, pre.4, pre.5,
                   post.1, post.2, post.3, post.4, post.5,
                   fup.1, fup.2, fup.3, fup.4, fup.5) ~  treatment * gender,
             data = OBrienKaiser)

Sigma <- sigma(mod_OK)

test_that("sigma works", {
  expect_equal(dim(Sigma), c(15, 15))
})


test_that("sigma works for manova", {
  expect_equal(sigma(manova(mod_OK)), Sigma)
})



test_that("sigma.mlm gives previous results", {
  expect_snapshot(Sigma)
})






