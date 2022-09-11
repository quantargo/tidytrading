library(tidytrading)

getSymbols("^GSPC", from="2007-01-01")
#####
# workaround to xts Date handling, remove later
ttz <- Sys.getenv("TZ")
Sys.setenv(TZ="UTC")

suppressWarnings(rm("order_book.macross", pos=.strategy))
suppressWarnings(rm("account.macross", "portfolio.macross", pos=.blotter))
suppressWarnings(rm("account.st", "portfolio.st", "stock.str", "stratMACROSS", "start_t", "end_t"))


stock.str <-"GSPC" # what are we trying it on
currency("USD")
stock(stock.str, currency="USD", multiplier=1)

initEq <- 1000000
portfolio.st <- "emacross"
account.st <- "emacross"
initPortf(portfolio.st, symbols=stock.str)
initAcct(account.st, portfolios=portfolio.st, initEq=initEq)
initOrders(portfolio=portfolio.st)
#####
stratMACROSS <- strategy("emacross") |>
  add.indicator(name = "EMA", arguments = list(x=quote(Cl(mktdata)), n=50), label="ma50") |>
  add.indicator(name = "EMA", arguments = list(x=quote(Cl(mktdata)[,1]), n=200), label="ma200") |>
  add.signal(name="sigCrossover", arguments = list(columns=c("ma50","ma200"),
                                                   relationship="gte"), label="ma50.gt.ma200") |>
  add.signal(name="sigCrossover", arguments = list(column=c("ma50","ma200"), relationship="lt"),
             label="ma50.lt.ma200") |>
  add.rule(name='ruleSignal',
           arguments = list(sigcol="ma50.gt.ma200",sigval=TRUE, orderqty=100,
                            ordertype='market', orderside='long'),type='enter') |>
  add.rule(name='ruleSignal',
           arguments = list(sigcol="ma50.lt.ma200",sigval=TRUE, orderqty='all',
                            ordertype='market', orderside='long'),type='exit')
out <- applyStrategy(strategy=stratMACROSS , portfolios=portfolio.st)

chart.Posn(Portfolio="emacross", Symbol="GSPC")
add_EMA(n=50, on=1, col="blue")
add_EMA(n=200, on=1)
