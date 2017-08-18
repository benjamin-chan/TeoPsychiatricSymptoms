fitModel <- function (y, x, covar = NULL) {
  if (is.null(covar)) {
    f <- formula(sprintf("%s ~ %s", y, x))
  } else {
    f <- formula(sprintf("%s ~ %s + %s", y, x, paste(covar, collapse = " + ")))
  }
  M <- lm(f, data = df)
  list(summary = M %>% summary(),
       plotResid = M %>% plotResid("fmss", x))
}
