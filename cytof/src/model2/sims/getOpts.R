library(optparse)

getOpts = function() {
  option_list = list(
    make_option("--J", type='integer'),
    make_option(c("--mcmc_k_init","-k"), type='integer'),
    make_option(c("--data_size","-n"), type='integer'),
    make_option(c("--use_simple_z", "-z"), type='integer'),
    make_option(c("--outdir", "-o"), type='character'),
    make_option("--random_K", type='integer', default=1),
    make_option("--B", type='integer'),
    make_option("--burn", type='integer'),
    make_option("--thin", type='integer', default=1),
    make_option("--prop_train", type='double', default=0.1),
    make_option("--seed_data", type='integer', default=1),
    make_option("--seed_mcmc",type='integer', default=1),
    make_option(c("--warmup", "-w"),type='integer', default=1000),
    make_option("--ncores",type='integer', default=8)
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
