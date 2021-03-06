% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/yZ_inspect.R
\name{yZ_inspect}
\alias{yZ_inspect}
\title{Plot y and Z together}
\usage{
yZ_inspect(out, y, zlim, i, thresh = 0.7, col = list(blueToRed(7),
  greys(10))[[1]], prop_lower_panel = 0.3, is.postpred = FALSE,
  decimals_W = 1, na.color = "transparent", fy = function(lami) {    
  abline(h = cumsum(table(lami)) + 0.5, lwd = 3, col = "yellow", lty = 1)
  }, fZ = function(Z) abline(v = 1:NCOL(Z) + 0.5, h = 1:NROW(Z) + 0.5,
  col = "grey"), ...)
}
\arguments{
\item{fy}{function to execute after making y image}

\item{fZ}{function to execute after making Z image}
}
\description{
Plot y and Z together
}
