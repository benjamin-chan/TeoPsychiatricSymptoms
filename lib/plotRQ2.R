plotRQ2 <- function(df, x, title) {
  require(ggplot2)
  df %>% 
    select(record_id, x, indPTSD, indPHQ, indAuditC, indDSISS) %>% 
    gather(key = variable, value = value, -record_id, -eval(parse(text = x))) %>% 
    filter(!is.na(value) & !is.na(eval(parse(text = x)))) %>% 
    mutate(variable = case_when(variable == "indPTSD" ~ "PC-PTSD",
                                variable == "indPHQ" ~ "PHQ-2",
                                variable == "indAuditC" ~ "AUDIT-C",
                                variable == "indDSISS" ~ "DSI-SS")) %>% 
    mutate(variable = factor(variable, levels = c("PC-PTSD", "PHQ-2", "AUDIT-C", "DSI-SS"))) %>% 
    mutate(value = factor(value, levels = c(FALSE, TRUE), labels = c("Negative", "Positive"))) %>% 
    mutate(!!x := factor(eval(parse(text = x)))) %>% 
    ggplot() +
    ggtitle(sprintf("Psychiatric symptoms by\n%s", title)) +
    aes(x = eval(parse(text = x)), color = value, fill = value) +
    geom_bar(data = . %>% filter(value == "Negative"), aes(y = ..count.. * (-1)), alpha = 1/1) +
    geom_bar(data = . %>% filter(value == "Positive"), alpha = 1/1) +
    scale_x_discrete("") +
    scale_y_continuous("Count", breaks = seq(-300, 300, 100), labels = abs(seq(-300, 300, 100))) +
    scale_color_brewer("Screened", palette = "Set1") + 
    scale_fill_brewer("Screened", palette = "Set1") + 
    facet_wrap(~ variable) +
    coord_flip() +
    theme(legend.position = "top",
          plot.title = element_text(hjust = 0.5))
}
