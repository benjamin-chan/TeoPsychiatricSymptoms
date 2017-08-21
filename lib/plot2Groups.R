plot2Groups <- function (y, x, ylab = "Y", xlab = "X") {
  require(ggplot2)
  require(RColorBrewer)
  df %>% 
    filter(!is.na(eval(parse(text = y))) & !is.na(eval(parse(text = x)))) %>% 
    ggplot() + 
    aes(x = eval(parse(text = x)), 
        y = eval(parse(text = y)), 
        fill = eval(parse(text = x)), 
        color = eval(parse(text = x))) + 
    geom_violin(alpha = 1/1) + 
    scale_x_discrete(xlab) + 
    scale_y_continuous(ylab) +
    scale_fill_brewer(xlab, palette = "Set1") +
    scale_color_brewer(xlab, palette = "Set1") +
    theme(legend.position = "none")
}
