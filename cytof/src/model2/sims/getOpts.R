library(optparse)

getOpts = function() {
  option_list = list(
    make_option("--J", type='integer'),
    make_option("--mcmc_k_init", type='integer'),
    make_option("--data_size", type='integer'),
    make_option("--use_simple_z", type='integer'),
    make_option("--outdir", type='string'),
    make_option("--B", type='integer'),
    make_option("--burn", type='integer'),
    make_option("--thin", type='integer', default=1),
    make_option("--prop_train", type='double', default=0.1),
    make_option("--seed_data", type='integer', default=1),
    make_option("--seed_mcmc",type='integer', default=1)
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
