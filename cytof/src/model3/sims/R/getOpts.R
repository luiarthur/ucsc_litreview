library(optparse)

getOpts = function() {
  option_list = list(
    make_option("--N", type='integer'),
    make_option("--ncores", type='integer', default=1),
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
