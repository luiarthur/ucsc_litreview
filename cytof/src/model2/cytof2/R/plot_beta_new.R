get_beta_new = function(y=c(-3, -2, -1), p_target=c(.1, .99, .01), plotting=FALSE) {
  #' Compute betas from y and p_target (new version)
  #' @export
  # TODO

  b0 = logit(p_target[2])
  b1 = (b0 - logit(p_target[1])) / (y[2] - y[1])^2
  x = -(logit(p_target[3]) - b0) / (y[3] - y[2])^.5 / b1

  c(b0=b0, b1=b1, x=x, c0=y[2])
}

pm = function(b0, b1, x, c0, y) {
  z = ifelse(y < c0,
             b0 - b1 * (y-c0)^2,
             b0 - b1 * x * (y-c0)^.5)

  logistic(z)
}

p_missing_new = function(o, i, j, y, c0) {
  #' Compute probability of missing across a grid of values (y)
  #' @param o A list containing the parameters from one iteration of MCMC 
  #' @param i Index for sample
  #' @param j Index for marker
  #' @param y A grid of values to compute the probabilities
  #' @param c0 Basically a spline point
  #' @export
  # TODO

  J = NROW(o$Z)

  b0ij <- matrix(o$beta_0, ncol=J)[i,j]
  b1j <- o$beta_1[j]
  xj = o$x[j]

  z = ifelse(y < c0,
             b0ij - b1j * (y-c0)^2,
             b0ij - b1j * xj * (y-c0)^.5)

  logistic(z)
}


plot_prob_missing_new <- function(mcmc, i, j, c0, q=c(.025,.975),
                                  y_grid=seq(-12,12,len=50), 
                                  plot_line=TRUE, plot_area=TRUE,
                                  addToExistingPlot=FALSE, 
                                  col.line='blue',col.area=rgb(0,0,1,.1), ...) {
  #' Plot the posterior distribution of p_inj across grid of values (y_grid)
  #' @param mcmc The output from cytof_fit
  #' @export

  p_curve_ij = sapply(mcmc, p_missing_new, i, j, y_grid, c0)
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

add_beta_prior_new <- function(prior, yy=seq(-10,10,l=100), SS=1000, ret=FALSE) {
  c0 = prior$c0
  bb_samps = rnorm(SS, prior$m_betaBar,sqrt(prior$s2_betaBar))
  b0_samps = rnorm(SS, bb_samps, sqrt(prior$s2_beta0))
  b1_samps = rgamma(SS, prior$a_beta, prior$b_beta)
  x_samps = rgamma(SS, prior$a_x, prior$b_x)
  p_samps = sapply(1:SS, function(s) {
    pm(b0_samps[s], b1_samps[s], x_samps[s], c0, yy)
    #ifelse(yy < prior$c0,
    #       logistic(b0_samps[s] - b1_samps[s] * (yy-c0)^2),
    #       logistic(b0_samps[s] - b1_samps[s] * x_samps[s] * (yy-c0)^.5))
  })
  p_lo = apply(p_samps, 1, quantile, .025)
  p_hi = apply(p_samps, 1, quantile, .975)
  p_med = apply(p_samps, 1, quantile, .5)
  p_mean = rowMeans(p_samps)
  color.btwn(yy, p_lo, p_hi, from=yy[1], to=yy[length(yy)],
             col.area=rgb(1,0,0,.2))
  lines(yy,p_mean,col='red', lwd=1, lty=2)
  lines(yy,p_med,col='red', lwd=3, lty=2)

  if (ret) p_samps
}

plot_beta_new <- function(mcmc, missing_count, dat=NULL, prior=NULL) {
  compareWithData = !is.null(dat)

  c0 = prior$c0
  I <- length(last(mcmc)$missing_y_mean)
  J <- NROW(mcmc[[1]]$Z)
  K <- NCOL(mcmc[[1]]$Z)

  ### beta ###
  beta_0 = sapply(mcmc, function(o) c(o$beta_0))
  beta_0_mean = rowMeans(beta_0)
  beta_0_ci = t(apply(beta_0, 1, quantile, c(.025,.975)))
  b0_ylim = range(c(beta_0_ci))
  
  a = sapply(c(t(missing_count) / 30), function(x) max(min(x,1),.1))
  if (compareWithData) {
    if (length(unique(c(dat$b0))) > 1) {
      plot(c(dat$b0), beta_0_mean, main='b0', ylim=b0_ylim)
      add.errbar(beta_0_ci, x=c(dat$b0))
      abline(0,1)
    } else {
      b0_ylim = range(b0_ylim, dat$b0[1])
      plot(beta_0_mean, main='b0', pch=20, cex=2, fg='grey', col=rgb(0,0,1,a),
           ylim=b0_ylim)
      add.errbar(beta_0_ci, x=1:(I*J), lty=2, col=rgb(0,0,1,.3))
      abline(h=c(dat$b0[1],0),col='grey')
    }
  } else {
      plot(beta_0_mean, main='b0', pch=20, cex=2, fg='grey', col=rgb(0,0,1,a))
      add.errbar(beta_0_ci, x=1:(I*J), lty=2, col=rgb(0,0,1,.3))
  }
  
  # betaBar_0
  betaBar_0 = sapply(mcmc, function(o) o$betaBar_0)
  betaBar_0_mean <- rowMeans(betaBar_0)
  betaBar_0_ci <- t(apply(betaBar_0, 1, quantile, c(.025,.975)))

  # x
  c0 = prior$c0
  x = sapply(mcmc, function(o) o$x)
  x_ci = t(apply(x, 1, quantile, c(.025,.975)))
  plot(rowMeans(x), xlab='x', col=rgb(0,0,1), cex=2, fg='grey', pch=20,
       ylim=range(c(x_ci)))
  add.errbar(x_ci, x=1:J, lty=2, col=rgb(0,0,1,.5))
  if (compareWithData) {
    abline(h=c(dat$x[1],0),col='grey')
  }
  
  # beta_1
  beta_1 = sapply(mcmc, function(o) o$beta_1)
  beta_1_mean = rowMeans(beta_1)
  beta_1_ci = t(apply(beta_1, 1, quantile, c(.025,.975)))
  b1_ylim = range(c(beta_1_ci))
  if (compareWithData) {
    if (length(unique(dat$b1)) > 1) {
      plot(dat$b1, beta_1_mean, main='b1', ylim=b1_ylim)
      add.errbar(beta_1_ci, x=dat$b1)
      abline(0,1)
    } else {
      b1_ylim = range(b1_ylim, dat$b1[1])
      plot(beta_1_mean, main='b1', pch=20, col=rgb(0,0,1), cex=2, fg='grey',
           ylim=b1_ylim)
      add.errbar(beta_1_ci, x=1:J, lty=2, col=rgb(0,0,1,.5))
      abline(h=dat$b1[1],col='grey')
    }
  } else {
    plot(beta_1_mean, main='b1', pch=20, col=rgb(0,0,1), cex=2, fg='grey')
    add.errbar(beta_1_ci, x=1:J, lty=2, col=rgb(0,0,1,.5))
  }
  
  # Prob of missing
  if (compareWithData) {
    true_prob_miss <- 
      rep(list(list(Z=matrix(0,J,K),
                    x=dat$x,
                    c0=dat$c0,
                    beta_0=dat$b0,
                    beta_1=as.matrix(dat$b1))), 1)
  }

  ys <- seq(-12,12,l=100)
  plot(ys, ys, ylim=0:1, type='n', fg='grey', xlab='y', ylab='prob of missing')
  if (!is.null(prior)) add_beta_prior_new(prior, y=ys)
  title(main='Prob of missing')
  for (i in 1:I) for (j in 1:J) {
    r=135/255; g=206/255; b=250/255
    plot_prob_missing_new(mcmc, i, j, c0, plot_line=FALSE, col.area=rgb(r,g,b,.5), y=ys)
  }
  for (i in 1:I) for (j in 1:J) {
    plot_prob_missing_new(mcmc, i, j, c0, addT=TRUE, plot_area=FALSE, y=ys, col.line=j)
  }
  abline(v=0, col='grey')

  if (compareWithData) {
    plot_prob_missing_new(true_prob_miss,1,1, c0, col.line='black', add=T, lty=2, lwd=3, y=ys)
  }
  
  
  par(mfrow=c(4,2), mar=mar.ts(), oma=oma.ts())
  for (j in 1:J){
    plot(ys, ys, ylim=0:1, type='n', fg='grey', xlab='y',
         xaxt='n',
         ylab=paste0('prob of missing: ', j))
    if (j %% 8 == 0 || j %% 8 == 7) { axis(1, fg='grey') }
    abline(v=c(-5,0,5), col='grey', lty=2)
    for (i in 1:I) {
      plot_prob_missing_new(mcmc, i, j, c0, addT=TRUE, plot_a=T, y=ys, col.line=i+1, lwd=2)
      if (compareWithData) {
        plot_prob_missing_new(true_prob_miss,1,1, c0, col.line='black', add=T, lty=2, lwd=3)
      }
    }
  }
  par(mfrow=c(1,1), mar=mar.default(), oma=oma.default())
}


