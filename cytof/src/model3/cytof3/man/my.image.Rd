% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/myimage.R
\name{my.image}
\alias{my.image}
\title{Plotting an image with missing values}
\usage{
my.image(Z, col = grey(seq(1, 0, len = 2)), na.color = "transparent",
  fg = "grey", f = function(dat) stopifnot(TRUE), truncate = TRUE,
  rm0Cols = FALSE, addLegend = FALSE, nticks = 11, zlim = range(Z),
  cex.y.leg = 1, color.bar.digits = 1, ...)
}
\description{
Plotting an image with missing values
}
