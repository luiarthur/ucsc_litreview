A second simulation study was conducted to investigate how our model performs
when the underlying $Z$ matrix is more complex (i.e. the columns are not
linearly independent). We therefore simulate data under the criterion listed
in the previous section, with the new $Z$ matrix.

## Simulated Data

Figures \ref{complex1} to \ref{complex3} display the simulated data in
simulation study II.

![Simulated data $Y_1$](img/complex/rawDat001.png){ id=complex1 height=60% }

![Simulated data $Y_2$](img/complex/rawDat002.png){ id=complex2 height=60% }

![Simulated data $Y_3$](img/complex/rawDat003.png){ id=complex3 height=60% }

Observations were recorded as missing with the same probabilities as in the
previous simulation.

## Results

Once again, the parameters of greatest interest in this model are $Z$, $W$, and
$\mu^*$.  Summaries of the posterior distributions from the simulations for
those parameters will be discussed in this section.

### Posterior Estimate of $Z$

Figure \ref{trueComplexZ} shows the true $Z$ matrix used in this simulation 
study.

![A complex $Z$ matrix used for simulation study.](img/complex/trueZ.pdf){ id=trueComplexZ height=60% }

In Figure \ref{z3Complex}, we see that when $K=3$ (smaller than the true $K$),
the model learns only parts of the true feature allocation matrix. In this
case, only the first two columns are correctly recovered. The third column
resembles a combination of the third and fourth columns of the true $Z$.

\beginmyfig
![](img/complex/Z_point_k3.pdf){ height=40% }
![](img/complex/Z_k3.pdf){ height=40% }
\caption{$Z$ Point estimate (left) and posterior mean (right) for 3 columns}
\label{z3Complex}
\endmyfig

Figure \ref{z4Complex} shows the posterior mean for $Z$ when the number of
columns is fixed at 4 (the truth). The structure of $Z$ is completely recovered
in this case.

\beginmyfig
![](img/complex/Z_point_k4.pdf){ height=40% }
![](img/complex/Z_k4.pdf){ height=40% }
\caption{$Z$ Point estimate (left) and posterior mean (right) for 4 columns}
\label{z4Complex}
\endmyfig

Figure \ref{z7Complex} shows the posterior mean for $Z$ when the number of
columns is fixed at 7 (larger than the truth). Similar to the previous study,
when $K$ is mis-specified larger than the truth, the true $Z$ can still be
recovered.

\beginmyfig
![](img/complex/Z_point_k7.pdf){ height=40% }
![](img/complex/Z_k7.pdf){ height=40% }
\caption{$Z$ Point estimate (left) and posterior mean (right) for 7 columns}
\label{z7Complex}
\endmyfig

### Posterior Estimate of $W$

The conclusions drawn from the posterior means of $W$ under different $K$'s are
similar to the ones drawn in the previous study. Namely, when $K$ is smaller,
the proportions are aggregated over some columns. When $K$ is correct and $Z$
is recovered, $W$ is recovered. When $K$ is larger and $Z$ is correct, $W$ is 
recovered, with the extra columns in $W$ shrinking towards 0.

The posterior means of $W$ will merely be listed here. The true $W$ is the same
as the one used in the previous simulation.

The posterior mean of the $W$ matrix for which $K=3$ is
$$
\hat{W}_3 = \input{img/complex/W_mean_k3.tex}
$$

The posterior mean of the $W$ matrix for which $K=4$ is
$$
\hat{W}_4 = \input{img/complex/W_mean_k4.tex}
$$

The posterior mean of the $W$ matrix for which $K=7$ is
$$
\hat{W}_7 = \input{img/complex/W_mean_k7.tex}
$$

### Posterior Estimate of $\mu^*$

When $Z$ is not recovered completely, $\mu^*$ cannot be recovered completely.
This is the case when $K=3$. See Figure \ref{musComplex3}.

![$\mu^*$ Posterior mean for 3 columns](img/complex/mus_k3.pdf){ id=musComplex3 height=60% }

When $Z$ is recovered completely (and $K > K_{\text{TRUE}}$), $\mu^*$ can be
recovered as long as there are data associated with the particular
$\mu^*_{zij}$.  Notice that there are 9 values of $\mu^*$ that are not
recovered in Figures \ref{musComplex4} and \ref{musComplex7}. A closer
examination of data in Figures \ref{complex1} to \ref{complex3} will reveal
that there are no observations less than 0 for $j=30,31,32$. Consequently, there
are 9 values of $\mu^*_{0ij}$ where the parameters are sampled from the prior, 
explaining the large credible intervals.

![$\mu^*$ Posterior mean for 4 columns](img/complex/mus_k4.pdf){ id=musComplex4 height=60% }

![$\mu^*$ Posterior mean for 7 columns](img/complex/mus_k7.pdf){ id=musComplex7 height=60% }
