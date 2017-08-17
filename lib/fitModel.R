fitModel <- function (x, covar = NULL) {
  if (is.null(covar)) {
    f <- formula(sprintf("%s ~ %s", "fmss", x))
  } else {
    f <- formula(sprintf("%s ~ %s + %s", "fmss", x, paste(covar, collapse = " + ")))
  }
  M <- lm(f, data = df)
  list(summary = M %>% summary(),
       plotResid = M %>% plotResid("fmss"))
}
