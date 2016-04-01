#!/usr/bin/env Rscript

# Standard error = Standard deviation / sqrt(n)
stderr <- function(x) sd(x)/sqrt(length(x))

# Read data from stdin and aggregate
df <- read.table(file("stdin"), sep="\t", header=FALSE, col.names=c("Real", "User", "Sys"))

for (i in names(df)) {
  cat(sprintf("  %-4s  %f±%fms\n", i, mean(df[[i]]), stderr(df[[i]])))
}
