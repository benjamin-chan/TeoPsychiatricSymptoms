fitModel <- function (df, y, x, covar = NULL, int = NULL) {
  if (is.null(covar)) {
    f <- formula(sprintf("%s ~ %s", y, x))
  } else {
    f <- formula(sprintf("%s ~ %s + %s", y, x, paste(covar, collapse = " + ")))
  }
  if (!is.null(int)) {
    f <- update(f, sprintf("~ . + %s + %s", int, paste(x, int, sep = "*")))
  }
  M <- glm(f, data = df, family = "binomial")
  list(modelObject = M,
       summary = M %>% summary())
}
