plotResid <- function (lmObj, y) {
  df %>% 
    mutate(yhat = predict(lmObj, newdata = .),
           resid = eval(as.name(y)) - predict(lmObj, newdata = .)) %>% 
    select(c(eval(as.name(y)), yhat, resid)) %>% 
    ggplot() +
    aes(x = yhat, y = resid) +
    geom_abline(intercept = 0, slope = 0) +
    geom_point(alpha = 1/2)
}