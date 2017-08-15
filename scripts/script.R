setwd("~/Projects/TeoPsychiatricSymptoms/scripts")

library(checkpoint)
checkpoint("2017-07-01", use.knitr = TRUE)

Sys.time0 <- Sys.time()

sink("script.log")
files <- c("header.yaml",
           "preamble.Rmd",
           "readData.Rmd",
           "analyzeRQ1.Rmd",
           "analyzeRQ2.Rmd",
           "analyzeRQ3.Rmd")
f <- file("master.Rmd", open = "w")
for (i in 1:length(files)) {
    x <- readLines(files[i])
    writeLines(x, f)
}
close(f)
library(knitr)
library(rmarkdown)
opts_chunk$set(echo = FALSE, fig.path = "../figures/", dpi = 300)
knit("master.Rmd", output = "../docs/report.md")
# pandoc("../docs/analysis_summary.md", format = "docx")
file.remove("master.Rmd")
sink()

sink("session.log")
list(completionDateTime = Sys.time(),
     executionTime = Sys.time() - Sys.time0,
     sessionInfo = sessionInfo())
sink()
