#!/bin/bash

### PARALLEL SETTINGS ###
MAX_CORES=4
i=0

### ARGUMENTS ###
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
### End of ARGUMENTS ###

for n in $N_FACTOR
do
  i=$((i+1))

  # Need backslash at the end!
  outdir="${OUTDIR}/N$n/"
  mkdir -p $outdir

  cmd="Rscript sim.R --N_factor=$n --J=$J --L0=$L0 --L1=$L1 --K_TRUE=$K_TRUE --niter=$niter --burn=$burn --K_MCMC=$K_MCMC --L_MCMC=$L_MCMC --outdir=$outdir"
  cmd="$cmd > ${outdir}/log.txt"
  sem -j $MAX_CORES $cmd
  echo "Simulation $i: $outdir"
done
