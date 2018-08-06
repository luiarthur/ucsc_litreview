#!/bin/bash

# TODO: Make this more sophisticated later

N_FACTOR="100 1000 10000"
J=32
L0=5
L1=3
K_TRUE=4

niter=2000
burn=2000
K_MCMC=10
L_MCMC=5

OUTDIR='log/sim-study/'

for n in N_FACTOR
do
  outdir="${OUTDIR}/N$n/"
  Rscript sim.R --N_factor=$n --J=$J --L0=$L0 --L1=$L1 --K_TRUE=$K_TRUE --niter=$niter --burn=$burn --K_MCMC=$K_MCMC --L_MCMC=$L_MCMC --outdir=$outdir &
done
