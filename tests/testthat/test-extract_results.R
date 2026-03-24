data(OBrienKaiser, package = "carData")
mod_OK <- lm(cbind(pre.1, pre.2, pre.3, pre.4, pre.5,
                   post.1, post.2, post.3, post.4, post.5,
                   fup.1, fup.2, fup.3, fup.4, fup.5) ~  treatment * gender,
             data = OBrienKaiser)

phase <- factor(rep(c("pretest", "posttest", "followup"), c(5, 5, 5)),
                levels=c("pretest", "posttest", "followup"))
hour <- ordered(rep(1:5, 3))
idata <- data.frame(phase, hour)


# first test
test1 <- car::linearHypothesis(mod_OK, c("treatment1:gender1", "treatment2:gender1"),
                         title = "treatment:gender:phase:hour",
                         idata = idata,
                         idesign = ~ phase * hour,
                         iterms = "phase:hour")
results1 <- extract_results(test1)


# second test using M and L matrix
L <- rbind(c(1, 0, 0, 0, 0, 0))
M <- cbind(rep(c(1/5, 0, -1/5), each = 5))

test2 <- car::linearHypothesis(mod_OK, L, P = M, test = "Wilks")
results2 <- extract_results(test2)


test_that("extracting results works for multiple tests", {
  expect_equal(dim(results1), c(4, 6))
  expect_equal(names(results1),  c("df", "test stat", "approx F", "num df",
                                  "den df", "p-value"))
  expect_equal(rownames(results1), c("Pillai", "Wilks", "Hotelling-Lawley",
                                    "Roy"))
})


test_that("extracting results works for one test", {
  expect_equal(dim(results2), c(1, 6))
  expect_equal(names(results2),  c("df", "test stat", "approx F", "num df",
                                  "den df", "p-value"))
  expect_equal(rownames(results2), "Wilks")
})



test_that("extracting results has the correct class", {
  expect_s3_class(results1, c("anova", "dataframe"))
  expect_s3_class(results2, c("anova", "dataframe"))
})


test_that("extracting results gives previous results", {
  expect_snapshot(results1)
  expect_snapshot(results2)
})

