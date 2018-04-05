gibbs = function(init, update, B, burn, print_every=0) {
  ### Preallocated Memory
  out = lapply(as.list(1:B), function(b) init)

  ### Gibbs Update
  for (i in 1:(B+burn)) {
    if (i - burn <= 1) {
      update(out[[1]])
    } else {
      out[[i - burn]] = out[[i - burn - 1]]
      update(out[[i - burn]])
    }

    ### Print progress
    if (print_every > 0 && i %% print_every == 0) {
      cat("\rProgress: ", i, " / ", B+burn)
    }
  }
  cat("\n")

  out
}

