library(tidytrading)
library(recipes)
library(TTR)

port <- get_symbols("^GSPC", from="2007-01-01")
rec <- recipe(port) |>
  step_mutate(ma50 = EMA(close, n = 50)) |>
  step_mutate(ma200 = EMA(close, n = 200))

strat <- function(.data, position, ...) {
  open_orders <- tail(.data, 1) |>
    mutate(target_qty = ifelse(ma50 > ma200), 100, 0) |>
    inner_join(position, by = "symbol") |>
    mutate(order_qty = target_qty - position_qty) |>
    filter(order_qty != 0)
  order(sym = open_orders$symbol,
        qty=open_orders$order_qty, type="market")
}

samp <- sliding_window(port, lookback = 300)
multi_metric <- metric_set(sharpe, maxdd, ccc_with_bias)
order_txn <- backtest(strat, data = rec, resamples = samp)
order_txn |> multi_metric() # Calculate metrics
order_txn |> autoplot() # Plot similar to blotter::chart.Posn
