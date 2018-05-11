# Trouble Shooting

## GSL errors 
You may get errors like `undefined symbol: gsl_rng_mt19937` if gsl
is not properly installed or linked. Consider checking if the path 
variable is set correctly. If you have a user-installed gsl (as opposed to
a system-installed gsl), your `~/.bashrc` should have something like this:

```bash
export GSL_HOME="$HOME/path/to/gsl/"
export LIBRARY_PATH="${GSL_HOME}/include:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${GSL_HOME}/lib:${LD_LIBRARY_PATH}"
````


