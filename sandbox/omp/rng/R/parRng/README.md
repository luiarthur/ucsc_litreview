# README

This package depends on the GSL library.

That is GSL needs to be pre-installed.

To install on Ubuntu, do

```bash
sudo apt install gsl-bin libgsl0-dev
```

The files `configure.in` and `src/Makevars.in` together generate 
`src/Makevars`. Therefore, do not directly modify `src/Makevars`.
Instead, make the appropriate edits to `configure.in` and `src/Makevars.in`.
See section 5 of the [RcppGSL vignette][1].

[1]: https://cran.r-project.org/web/packages/RcppGSL/vignettes/RcppGSL-intro.pdf

