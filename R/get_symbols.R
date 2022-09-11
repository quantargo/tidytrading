#' Download Stock Data From Yahoo
#'
#' A wrapper function for \link[tidyquant]{tq_get} to retrieve symbols from
#' Yahoo! Finance as \link[tsibble]{tsibble} time series.
#' @param sym character; Symbols to be retrieved.
#' @param ... Additional parameters passed to \link[tidyquant]{tq_get}
#' @importFrom tidyquant tq_get
# @importFrom tidyr nest
#' @importFrom tsibble as_tsibble
#' @importFrom rlang .data
#' @export
get_symbols <- function(sym, ...) {
  out <- tq_get(sym, ...) |>
    as_tsibble(key = .data$symbol, index = date)
    #nest(data = -symbol)

  class(out) <- c("portfolio", class(out))
  out
}
