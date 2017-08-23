getGtest <- function (modelObject, linfct = NULL) {
  require(multcomp)
  if (is.null(linfct)) {
    K <- diag(length(coef(modelObject)))[-1,]
    rownames(K) <- names(coef(modelObject))[-1]
    linfct <- K
  }
  modelObject %>% glht(linfct = linfct) %>% summary(test = Ftest()) %>% .[["test"]]
}
