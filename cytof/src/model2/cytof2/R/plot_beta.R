p_missing <- function(o, i, j, y) {
  #' Compute probability of missing across a grid of values (y)
  #' @param o A list containing the parameters from one iteration of MCMC 
  #' @param i Index for sample
  #' @param j Index for marker
  #' @param y A grid of values to compute the probabilities
  #' @export

  b0ij <- matrix(o$beta_0, ncol=J)[i,j]
  b1j <- o$beta_1[j]
  1 / (1 + exp(-b0ij + b1j * y))
}

plot_beta <- function(mcmc, i, j, q=c(.025,.975), y_grid=seq(-12,12,len=50), 
                      plot_line=TRUE, plot_area=TRUE, addToExistingPlot=FALSE, 
                      col.line='blue',col.area=rgb(0,0,1,.1), ...) {
  #' Plot the posterior distribution of p_inj across grid of values (y_grid)
  #' @param mcmc The output from cytof_fit
  #' @export

  p_curve_ij = sapply(mcmc, p_missing, i, j, y_grid)
  p_curve_ij_mean = rowMeans(p_curve_ij)
  p_curve_ij_ci = apply(p_curve_ij, 1, quantile, q)
  if(plot_line && addToExistingPlot) {
    lines(y_grid, p_curve_ij_mean, ylim=0:1, type='l', col=col.line, ...)
  } else if (plot_line && !addToExistingPlot) {
    plot(y_grid, p_curve_ij_mean, ylim=0:1, type='l', col=col.line, ...)
  } 
  if (plot_area) color.btwn(y_grid, ylo=p_curve_ij_ci[1,], yhi=p_curve_ij_ci[2,], 
                            from=min(y_grid), to=max(y_grid), col=col.area)
}


