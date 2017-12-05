plot_cytof_posterior <- function(mcmc, y, outdir='', sim=NULL, supress=c(),
                                 show_all_Z=FALSE, quant=c(.025,.975)) {
  fileDest = function(name) paste0(outdir, name)

  compareWithData = !is.null(sim)
  I = length(y)
  J = NCOL(y[[1]])

  if (outdir > "") pdf(fileDest("params.pdf"))

  ### Loglike ###
  ll <- sapply(mcmc, function(o) o$ll)
  plot(ll, main='log-likelihood', type='b',
       xlab='mcmc iteration', ylab='log-likelihood')

  ### Z ###
  if (!("Z" %in% supress)) {
    Z <- lapply(mcmc, function(o) o$Z)
    Z_mean <- matApply(Z, mean)
    Z_sd <- matApply(Z, sd)
    ord <- left_order(Z_mean>.5)

    if (show_all_Z) for (i in 1:length(mcmc)) {
      my.image(Z[[i]][,ord], main=paste0("Sampled Z at iteration ",i), ylab="1:J")
    }

    my.image(Z_sd[,ord], main="Posterior SD", ylab="1:J", addL=T)
    my.image(Z_mean[,ord], main="Posterior Mean", ylab="1:J", addL=T)
    if (sum(Z_mean>.5) > 0) {
      my.image(Z_mean[,ord]>.5, main="Posterior Mean", ylab="1:J", addL=T, rm0=TRUE)
    }

    if (compareWithData)
      my.image(sim$Z, main="True Z", ylab="1:J", addL=T)
  }

  ### W ###
  if (!("W" %in% supress)) {
    W <- lapply(mcmc, function(o) o$W)
    W_mean <- matApply(W, mean)
    W_sd <- matApply(W, sd)
    my.image(W_sd[,ord], mn=0, mx=.1, 
             ylab="I", xlab="K", main="Posterior SD: W", addL=TRUE)
    my.image(W_mean[,ord], ylab="I", xlab="K", main="Posterior Mean: W", addL=TRUE)

    if(compareWithData)
      my.image(sim$W, ylab="I", xlab="K", main="W: Truth", addL=TRUE)

    if (outdir > '') sink(fileDest('W.txt'))
    cat("Posterior Mean: W\n")
    print(W_mean)
    cat("True W\n")
    if(compareWithData) print(sim$W)
    if (outdir > '') sink()
  }

  ### beta ###
  if (!("beta" %in% supress)) {
    missing_count <- get_missing_count(y)
    plot_beta(mcmc, missing_count, sim)
  }

  ### mus ###
  if (!("mus" %in% supress)) {
    mus0 = sapply(mcmc, function(o) c(o$mus[,,1]))
    mus0_mean = rowMeans(mus0)
    mus0_ci = t(apply(mus0, 1, quantile, quant))

    # mus1
    mus1 = sapply(mcmc, function(o) c(o$mus[,,2]))
    mus1_mean = rowMeans(mus1)
    mus1_ci = t(apply(mus1, 1, quantile, quant))

    #mus posterior vs sim data
    if (compareWithData) {
      plot(c(c(sim$mus_0),c(sim$mus_1)), 
           c(c(mus0_mean), c(mus1_mean)), pch=20,fg='grey',
           col='blue', main='Posterior mu*',
           xlab='true mu*', ylab='posterior mean: mu*')
      abline(0,1, h=0, v=0, col='grey', lty=2)
      add.errbar(rbind(mus0_ci, mus1_ci),
                 x=c(c(sim$mus_0), c(sim$mus_1)), col=rgb(0,0,1,.2))
    }

    #mus posterior vs empirical est
    mus_est = get_mus_est(y)
    plot(c(c(mus_est$mus0),c(mus_est$mus1)),
         c(c(mus0_mean), c(mus1_mean)), pch=20,fg='grey',
         col='blue', main='Posterior mu*', xlab='empirical est of mu*',
         ylab='posterior mean: mu*')
    abline(0,1, h=0, v=0, col='grey', lty=2)
    add.errbar(rbind(mus0_ci, mus1_ci),
               x=c(c(mus_est$mus0), c(mus_est$mus1)), col=rgb(0,0,1,.2))
  }

  ### gams_0
  if (!('gams_0' %in% supress)) {
    gams_0 = sapply(mcmc, function(o) o$gams_0)
    gams_0_mean = rowMeans(gams_0)
    gams_0_ci = t(apply(gams_0, 1, quantile, quant))

    if (compareWithData) {
      plot(c(sim$gams_0), c(gams_0_mean), fg='grey',
           xlab='Data: gam0*', ylab='Posterior Mean: gam0*', 
           main=expression('Posterior'~gamma[0]^'*'),
           pch=20, col='blue')
      abline(0,1, col='grey')
      add.errbar(gams_0_ci, x=sim$gams_0, col=rgb(0,0,1,.2))
    } else {
      plot(c(gams_0_mean), fg='grey',
           xlab='Data: gam0*', ylab='Posterior Mean: gam0*', 
           main=expression('Posterior'~gamma[0]^'*'),
           pch=20, col='blue')
      add.errbar(gams_0_ci, col=rgb(0,0,1,.2))
    }
  }

  ### sig2
  if (!("sig2" %in% supress)) {
    sig2 = sapply(mcmc, function(o) o$sig2)
    sig2_mean = rowMeans(sig2)
    sig2_ci = t(apply(sig2, 1, quantile, quant))

    sig2_range = range(sig2_mean, sim$sig2)
    if (compareWithData) {
      plot(c(sim$sig2), c(sig2_mean), #xlim=sig2_range, ylim=sig2_range,
           pch=20, col='blue', fg='grey', xlab='truth', ylab='posterior mean',
           main=expression(sigma[ij]^2))
      abline(0,1, col='grey')
      add.errbar(sig2_ci, x=c(sim$sig2), col=rgb(0,0,1,.3))
    } else {
      plot(c(sig2_mean),
           pch=20, col='blue', fg='grey', xlab='truth', ylab='posterior mean',
           main=expression(sigma[ij]^2))
      add.errbar(sig2_ci, col=rgb(0,0,1,.3))
    }
  }

  # gams and sig2
  if (!('gs' %in% supress)) {
    gs <- sapply(mcmc, function(o) o$sig2 * (1 + o$gams_0))
    gs_mean <- rowMeans(gs)
    gs_ci <- t(apply(gs, 1, quantile, quant))

    if (compareWithData)  {
      dat_gs <- c(sim$sig2 * (sim$gams_0 + 1))
      plot(c(dat_gs), rowMeans(gs), pch=20, col='blue', fg='grey',
           xlab='truth', ylab='posterior mean',
           main=expression(sigma[ij]^2~(1+gamma[0][ij])))
      abline(0,1, col='grey')
      add.errbar(gs_ci, x=c(dat_gs), col=rgb(0,0,1,.3))
    } else {
      plot(c(gs_mean), pch=20, col='blue', fg='grey',
           xlab='truth', ylab='posterior mean',
           main=expression(sigma[ij]^2~(1+gamma[0][ij])))
      add.errbar(gs_ci, col=rgb(0,0,1,.3))
    }
  }

  ### v ###
  if (!('v' %in% supress)) {
    v <- sapply(mcmc, function(o) o$v)
    v_ci <- t(apply(v, 1, quantile, quant))
    plot(rowMeans(v), pch=20, cex=2, ,main='v: Posterior', fg='grey',
         xlab='k', ylab='v', ylim=c(0,1))
    add.errbar(v_ci, col=rgb(.1,.1,.1,.3))
    par(mfrow=c(5,2), mar=mar.ts(), oma=oma.ts())
    for (i in 1:nrow(v)) {
      plot(v[i,], type='l', ylab=paste0('v_',i,': trace plot'), xlab='', main='',
           fg='grey')
    }
    par(mfrow=c(1,1), mar=mar.default(), oma=oma.default())
  }
  
  ### H ###
  if (!('H' %in% supress)) {
    H <- sapply(mcmc, function(w) w$H)
    H_ci = t(apply(H, 1, quantile, quant))
    if (!('Z' %in% supress)) {
      plot(rowMeans(H), col=(Z_mean>.5)+3, pch=20, fg='grey', ylab='H',
           main='H: Posterior')
      add.errbar(H_ci, col=rgb(.1,.1,.1,.3))
    }
    #par(mfrow=c(4,2))
    #for (i in 1:nrow(H)) {plot(H[i,], type='l'); abline(h=0, col='grey')}
    #par(mfrow=c(1,1))
  }
  

  ### tau2
  if (!('tau2' %in% supress)) {
    tau2 <- t(sapply(mcmc, function(o) o$tau2))
    tit = if (compareWithData) {
      paste0('tau2_',0:1,': Truth=', c(sim$tau2_0, sim$tau2_1))
    } else {
      paste0('tau2_',0:1)
    }
    plotPosts(tau2, cnames=tit)
  }

  ### psi
  if (!('psi' %in% supress)) {
    psi <- t(sapply(mcmc, function(o) o$psi))
    tit = if (compareWithData) {
      paste0('psi',0:1,': Truth=', c(sim$psi_0, sim$psi_1))
    } else {
      paste0('psi',0:1)
    }
    plotPosts(psi, cnames=tit)
  }

  ### missing_y
  if(!('missing_y' %in% supress)) {
    missing_y <- lapply(as.list(1:I), function(i) lapply(mcmc, function(o) {
      matrix(o$missing_y[[i]], ncol=J)
    }))
    #missing_y_mean <- lapply(missing_y, function(m) Reduce("+", m) / length(m))
    missing_y_mean <- lapply(missing_y, function(yi_list) matApply(yi_list, mean))

    par(mfrow=c(4,2))
    for (i in 1:I) for (j in 1:J) {
      plot_dat(missing_y_mean, i, j, 
               xlim=c(-5,5), ylim=c(0,1), xlab=paste0('marker ',j))
    }
    par(mfrow=c(1,1))

    plot.histModel2(missing_y_mean, 
                    xlim=c(-5,5), main='Histogram of Imputed Data',
                    quant=c(.05,.95))
  }
  if (outdir > "") dev.off()

  ### missing_y: FIXME. Want to plot multiple pages like pdf
  if (!('missing_y' %in% supress)) {
    if (outdir > "") png(fileDest('imputes_%03d.png'))

    for (i in 1:I) {
      my.image(y[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE,
               xlab='markers', main=paste0('Data: y',i))
      my.image(missing_y_mean[[i]], mn=-5, mx=5, col=blueToRed(), addLegend=TRUE,
               xlab='markers', main=paste0('Data with imputed missing values: y',i))
    }

    for (i in 1:I) {
      bla <- ifelse(!is.na(y[[i]]), NA, missing_y_mean[[i]])
      my.image(bla, mn=-5, mx=5,
               col=blueToRed(), addLegend=TRUE, xlab='markers',
               main=paste0('Only Imputed Missing Values: y',i))
      if (compareWithData) {
        my.image(missing_y_mean[[i]] - sim$y_no_missing[[i]], mn=-3, mx=3,
                 col=blueToRed(), addLegend=TRUE, xlab='markers',
                 main=paste0('Posterior Mean - Full Data',i))
      }
    }
    if (outdir > "") dev.off()
  }
}

