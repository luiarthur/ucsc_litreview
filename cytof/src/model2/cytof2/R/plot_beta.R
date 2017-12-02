get_beta <- function(y=c(-5,-3), p_target=c(.99, .01), plotting=TRUE) {
  #' Compute betas from y and p_target
  #' @export

  logit <- function(p) p / (1-p)
  inv_logit <- function(x) 1 / (1+exp(-x))

  mod <- glm(p_target ~ y, family=binomial)
  b.hat <- mod$coef

  y_grid <- seq(-8,8,l=1000)
  p <- inv_logit(b.hat[1] + y_grid*b.hat[2])

  if (plotting) {
    plot(y_grid, p, pch=20, col='grey')
    points(y,p_target)
    abline(h=p_target, v=y,lty=2, col='grey')
  }

  b.hat
}

y_grid <- seq(-8,8,l=1000)
inv_logit <- function(x) 1 / (1+exp(-x))
p <- inv_logit(-60 + -15*y_grid)
plot(y_grid, p, xlim=c(-5,5)); abline(v=0)

#get_beta()

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


