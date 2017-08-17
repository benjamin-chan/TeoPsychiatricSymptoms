means2Group <- function (y, x) {
  df %>% 
    select(c(y, x)) %>% 
    filter(!is.na(eval(parse(text = y))) & !is.na(eval(parse(text = x)))) %>% 
    group_by_(x) %>% 
    summarize(mean = mean(eval(parse(text = y))),
              min = min(eval(parse(text = y))), 
              max = max(eval(parse(text = y))), 
              n = n()) %>%
    mutate(yvariable = y) %>% 
    mutate(freq = sprintf("%.01f%%", n / sum(n) * 100)) %>% 
    select(c("yvariable", x, "mean", "min", "max", "n", "freq"))
}
