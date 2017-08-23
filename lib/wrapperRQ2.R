wrapperRQ2 <- function (df, y, x, covar, linfct) {
  M0 <- fitModel(df, y, x)
  M <- fitModel(df, y, x, covar)
  tmp0 <- M0[["modelObject"]] %>% getGtest(linfct)
  tmp <- M[["modelObject"]] %>% getGtest(linfct)
  list(oddsratios = bind_rows(M0[["modelObject"]] %>% 
                                tidy(exponentiate = TRUE) %>% 
                                mutate(model = "Unadjusted") %>% 
                                select(model, everything()), 
                              M[["modelObject"]] %>% 
                                tidy(exponentiate = TRUE) %>% 
                                mutate(model = "Adjusted") %>% 
                                select(model, everything())) %>% 
                    rename(oddsratio = estimate),
       Ftests = bind_rows(data.frame(model = "Unadjusted", 
                                     F = tmp0$fstat, df1 = tmp0$df[1], df2 = tmp0$df[2], pValue = tmp0$pvalue, 
                                     stringsAsFactors = FALSE),
                          data.frame(model = "Adjusted", 
                                     F = tmp$fstat, df1 = tmp$df[1], df2 = tmp$df[2], pValue = tmp$pvalue, 
                                     stringsAsFactors = FALSE)),
       fit = bind_rows(M0[["modelObject"]] %>% 
                         glance() %>% 
                         mutate(model = "Unadjusted") %>% 
                         select(model, everything()),
                       M[["modelObject"]] %>% 
                         glance() %>% 
                         mutate(model = "Adjusted") %>% 
                         select(model, everything())))
}
