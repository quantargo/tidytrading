# An EMA 50/200 crossing strategy on SP500
library(quantmod)
library(PerformanceAnalytics)
# v0.4.20.2 from remotes::install_github("joshuaulrich/quantmod")
getSymbols("^GSPC")

sig <- EMA(Cl(GSPC), 50) > EMA(Cl(GSPC), 200)
pos <- ifelse(sig, 1, 0)
ret <- ROC(Ad(GSPC), type = "discrete")
ret_strat <- ret * lag(pos, 1)
ret_all <- cbind(ret_strat, ret)
colnames(ret_all) <- c("EMA50/200", "Buy&Hold")
charts.PerformanceSummary(ret_all)
