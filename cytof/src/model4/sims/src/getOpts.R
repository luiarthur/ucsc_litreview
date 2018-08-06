library(optparse)

getOpts = function() {
  option_list = list(
    make_option("--N_factor", type='integer'),
    make_option("--J", type='integer', default=32),
    make_option("--L0", type='integer', default=5),
    make_option("--L1", type='integer', default=5),
    make_option("--K_TRUE", type='integer', default=10),
    #
    make_option("--niter", type='integer', default=2000),
    make_option("--burn", type='integer', default=1000),
    make_option("--K_MCMC", type='integer', default=20),
    make_option("--L_MCMC", type='integer', default=5),
    #
    make_option("--use_repulsive", type='logical', default=FALSE),
    make_option(c("--outdir", "-o"), type='character')
  )

  opt_parser = OptionParser(option_list=option_list);
  opt = parse_args(opt_parser);

  if (opt$help) {
    print_help(opt_parser)
    q()
  } else opt_parser
}

getOrFail = function(x, opt_parser) {
  if (is.null(x)) {
    print_help(opt_parser)
    stop()
  } else x
}
