println = function(...) {
  x = unlist(list(...))
  cat(paste0(x, collapse=''), '\n')
}
