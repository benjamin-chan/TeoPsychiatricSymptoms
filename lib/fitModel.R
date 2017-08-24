fitModel <- function (df, y, x, covar = NULL) {
  if (is.null(covar)) {
    f <- formula(sprintf("%s ~ %s", y, x))
  } else {
    f <- formula(sprintf("%s ~ %s + %s", y, x, paste(covar, collapse = " + ")))
  }
  M <- glm(f, data = df, family = "binomial")
  list(modelObject = M,
       summary = M %>% summary())
}
