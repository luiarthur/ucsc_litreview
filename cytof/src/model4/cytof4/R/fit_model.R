#' Get column index of parameter
#'
#' @param name: name of parameter
#' @param samples: the samples object
#' @export
get_param = function(name, samples) {
  #which(sapply(colnames(out_samples), function(cn) grepl(name, cn)))
  which(sapply(colnames(samples), function(cn) 
               grepl(paste0(name,'\\[\\s*\\d+,\\s*\\d+\\]'), cn)))
}

#' Compile CyTOF model
#'
#' TODO: write documentation
#' @export
compile.cytof.model = function(y_ls, K, L, 
                               data=model.data(y_ls), 
                               constants=model.consts(y=y_ls, K=K, L=L),
                               inits=model.inits(y=y_ls),
                               print_mcmc_config=FALSE, 
                               showCompilerOutput=FALSE) {

  library(nimble) # silly bug, but I need this at the moment for nimbleOptions
  model = nimbleModel(model.code(), data=data, 
                      constants=constants, inits=inits)

  # THIS IS IMPORTANT! Without this, things break! 
  # I believe this populates the nodes with values within the support of their
  # respective parameters by simulating from the prior or simulating from
  # each model parameter once sequentially, like in one iteration of the MCMC
  # for the entire model.
  # TODO: Check if my thinking is correct
  model$simulate()

  model.conf = configureMCMC(model, print=print_mcmc_config)
  cmodel = compileNimble(model, showCompilerOutput=showCompilerOutput)

  model.conf$addMonitors(c('Z0', 'v', 'logProb_y'))
  model.conf$addMonitors2(c('lam', 'y', 'gam', 'eta'))

  model.mcmc = buildMCMC(model.conf)#, time=TRUE)
  cmodel = compileNimble(model.mcmc, project=model)

  return(cmodel)
}


#' Fit the CyTOF Model
#'
#' @param cmodel: compiled model (output from compile.cytof.model)
#' @param niter: number of MCMC iterations
#' @param nburnin: burn-in period
#' @param thin2: amount to thin by for large parameters (leave it as niter!)
#' @param ...: additional arguments in nimble::runMCMC
#' @return list(cmodel, timing)
#' @export
fit.cytof = function(cmodel, niter, nburnin, thin2=niter, warmup_period=0, ...) {
  if (warmup_period > 0) {
    print("Estimating time for MCMC...")
    warmup_period = as.integer(warmup_period)
    time_warmup_iters = 
      # Prefer this, because the current state is stored in cmodel
      system.time(cmodel$run(niter=warmup_period))
      # The following line is not preferred!
      #system.time(runMCMC(cmodel, niter=warmup_period, nburnin=0))
    seconds_per_iter = time_warmup_iters[3] / warmup_period
    print("Estimated time per iteration (in seconds):")
    print(seconds_per_iter)
  }

  time_model = system.time({
    if (nburnin > 0) {
      print("Burning...")
      cmodel$run(niter=nburnin)
    }

    print("Post-burn")
    cmodel$run(niter=niter, thin2=thin2, time=TRUE, ...)
  })
  print(time_model)

  list(cmodel=cmodel, timing=time_model)
}
