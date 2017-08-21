freq2Group <- function (y, x) {
  colMargin <- 
    df %>% 
    select(c(y, x)) %>% 
    filter(!is.na(eval(parse(text = y))) & !is.na(eval(parse(text = x)))) %>% 
    group_by_(x) %>% 
    summarize(N = n())
  df %>% 
    select(c(y, x)) %>% 
    filter(!is.na(eval(parse(text = y))) & !is.na(eval(parse(text = x)))) %>% 
    group_by_(y, x) %>% 
    summarize(n = n()) %>%
    merge(., colMargin, by = x) %>% 
    mutate(freq = n / N) %>% 
    arrange(eval(parse(text = x)), eval(parse(text = y)))
}
