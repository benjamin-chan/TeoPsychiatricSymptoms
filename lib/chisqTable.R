chisqTable <- function (a, b, data = df0, varlabel = NULL) {
  T <- 
    data %>% 
    select(c(a, b)) %>% 
    table()
  df <- 
    data %>% 
    group_by(get(a), get(b)) %>% 
    summarize(n = n()) %>% 
    rename(y = `get(a)`, x = `get(b)`) %>% 
    mutate(x = factor(x, levels = levels(data[, b]), ordered = TRUE))
  levels(df$x) <- gsub("Very or Extremely", "Very or\nExtremely", levels(df$x))
  list(rowvar = sprintf("%s: %s", a, varlabel %>% filter(name == a) %>% select(label)),
       colvar = sprintf("%s: %s", b, varlabel %>% filter(name == b) %>% select(label)),
       table = T %>% addmargins(),
       expected = chisq.test(T)$expected,
       residual = chisq.test(T)$residuals,
       propRow = prop.table(T, 1) %>% addmargins(margin = 2) %>% round(3),
       propCol = prop.table(T, 2) %>% addmargins(margin = 1) %>% round(3),
       chisq.test = chisq.test(T),
       data.frame = df)
}
