chisqTable <- function (a, b, data = df0, varlabel = NULL) {
  T <- 
    data %>% 
    select(c(a, b)) %>% 
    table()
  list(rowvar = sprintf("%s: %s", a, varlabel %>% filter(name == a) %>% select(label)),
       colvar = sprintf("%s: %s", b, varlabel %>% filter(name == b) %>% select(label)),
       table = T %>% addmargins(),
       expected = chisq.test(T)$expected,
       residual = chisq.test(T)$residuals,
       propRow = prop.table(T, 1) %>% addmargins(margin = 2) %>% round(3),
       propCol = prop.table(T, 2) %>% addmargins(margin = 1) %>% round(3),
       chisq.test = chisq.test(T))
}
