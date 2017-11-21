plotTable <- function (a, b, data = df, varlabel = NULL) {
  require(ggmosaic)
  G <- 
    data %>%
    ggplot() +
    geom_mosaic(aes(weight = n, x = product(x), fill = y), 
                na.rm = TRUE) +
    labs(title = sprintf("%s\n%s", a, varlabel %>% filter(name == a) %>% select(label))) +
    scale_x_productlist(sprintf("%s\n%s", b, varlabel %>% filter(name == b) %>% select(label))) +
    scale_y_continuous("Proportion") +
    scale_fill_brewer("", palette = "Set1") +
    theme(legend.position = "top",
          panel.grid.major.x = element_blank(),
          plot.title = element_text(hjust = 0.5))
  G
}
