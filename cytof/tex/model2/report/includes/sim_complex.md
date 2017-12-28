A second simulation study was conducted to investigate how our model performs
when the underlying $Z$ matrix is more complex (i.e. the columns are not
linearly independent). We therefore simulate data under the criterion listed
in the previous section, with the new $Z$ matrix.

### Simulated Data

Figure \ref{fig:complexDat} display the simulated data in
simulation study II.

\beginmyfig
![](img/complex/rawDat001.png){ height=30% }
![](img/complex/rawDat001.png){ height=30% }
![](img/complex/rawDat001.png){ height=30% }
\caption{Simulated Data. $Y_1$ (left), $Y_2$ (middle), $Y_3$ (right).}
\label{fig:complexDat}
\endmyfig

Observations were recorded as missing with the same probabilities as in the
previous simulation.

### Results

Once again, the parameters of greatest interest in this model are $Z$, $W$, and
$\mu^*$.  Summaries of the posterior distributions from the simulations for
those parameters will be discussed in this section.

#### Posterior Estimate of $Z$

Figure \ref{trueComplexZ} shows the true $Z$ matrix used in this simulation 
study.

![A complex $Z$ matrix used for simulation study.](img/complex/trueZ.pdf){ id=trueComplexZ height=40% }

In Figure \ref{fig:zpointComplex} (left), we see that when $K=3$ (smaller than the
true $K$), the model learns only parts of the true feature allocation matrix.
In this case, only the first two columns are correctly recovered. The third
column resembles a combination of the third and fourth columns of the true $Z$.

\beginmyfig
![](img/complex/Z_point_k3.pdf){ height=30% }
![](img/complex/Z_point_k4.pdf){ height=30% }
![](img/complex/Z_point_k7.pdf){ height=30% }
\caption{Posterior point-estimate for $Z$ of 3 columns (left), 4 columns (middle),
and 7 columns (right).}
\label{fig:zpointComplex}
\endmyfig


Figure \ref{fig:zpointComplex} (middle) shows the posterior mean for $Z$ when the
number of columns is fixed at 4 (the truth). The structure of $Z$ is completely
recovered in this case.

Figure \ref{fig:zpointComplex} (right) shows the posterior mean for $Z$ when the
number of columns is fixed at 7 (larger than the truth). Similar to the
previous study, when $K$ is mis-specified larger than the truth, the true $Z$
can still be recovered.

#### Posterior Estimate of $W$

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

#### Posterior Estimate of $\mu^*$

When $Z$ is not recovered completely, $\mu^*$ cannot be recovered completely.
This is the case when $K=3$. See Figure \ref{fig:musComplex} (left).

When $Z$ is recovered completely (and $K > K^{\text{TR}}$), $\mu^*$ can be
recovered as long as there are data associated with the particular
$\mu^*_{zij}$.  Notice that there are 9 values of $\mu^*$ that are not
recovered in Figures \ref{fig:musComplex} (middle) and \ref{fig:musComplex}
(right). A closer examination of data in Figures \ref{complexDat} to will
reveal that there are no observations less than 0 for $j=30,31,32$.
Consequently, there are 9 values of $\mu^*_{0ij}$ where the parameters are
sampled from the prior, explaining the large credible intervals.


\beginmyfig
![](img/complex/mus_k3.pdf){ height=32% }
![](img/complex/mus_k4.pdf){ height=32% }
![](img/complex/mus_k7.pdf){ height=32% }
\caption{$\mu^*$ Posterior mean vs. true $\mu^*$ for $K=3$ (left), $K=4$
(middle), and $K=7$ (right). Circles represent the posterior mean. Vertical
lines represent the 95\% credible intervals.  Triangles also represent the
posterior mean, but for $\mu_{zij}$ that have fewer than 30 corresponding
$Z_{j,\lambda_{in}}$. They should have large intervals.}
\label{fig:musComplex}
\endmyfig

