A second simulation study was conducted to investigate how our model performs
when the underlying $Z$ matrix is more complex (i.e. the columns are not
linearly independent). We therefore simulate data under the criterion listed
in the previous section, with the new $Z$ matrix.

## Simulated Data

The following figures depict the generated data.

![Simulated data $Y_1$](img/complex/rawDat002.png){ height=60% }

![Simulated data $Y_2$](img/complex/rawDat003.png){ height=60% }

![Simulated data $Y_3$](img/complex/rawDat004.png){ height=60% }

Observations were recorded as missing with the same probabilities as in the
previous simulation.


## Results

The parameters of greatest interest in this model are $Z$, $W$, and $\mu^*$.
Summaries of the posterior distributions from the simulations for those parameters
will be discussed in this section.

### Posterior Estimate of $Z$

Besides recovering the true $Z$ matrix for the case when the model uses a fixed
dimension for $Z$  equal to the true dimension of the true $Z$, we want to
understand how mis-specifying the dimension ($K$) would affect the model. The 
following figures provide some insight to this objective. Recall that in the
simulation truth, there are exactly four latent features. Figure \ref{trueComplexZ}
displays a simple latent feature matrix that was used in this simulation study.

![A complex $Z$ matrix used for simulation study.](img/complex/trueZ.pdf){ id=trueComplexZ height=60% }

Figure \ref{z3} shows the posterior mean for $Z$ when the number of columns is 
fixed at 3 (mis-specified as smaller). In this case, the model learns 3 of the
2 columns of $Z$ correctly. In the first column, we see that of the 8 markers that
are supposed to take on feature 1, one marker is not activated and two markers
are erroneously activated.

![$Z$ Posterior mean for 3 columns](img/complex/Z_k3.pdf){ id=zc3 height=60% }

Figure \ref{z4} shows the posterior mean for $Z$ when the number of columns is 
fixed at 4 (the truth). In this case, the posterior mean learns two of the four
columns of $Z$ correctly. By simply changing the random seed in the software
used to implement the algorithm, the true $Z$ matrix is completely recovered. This
suggests that the algorithm is slightly sensitive to the starting values 
of the MCMC. 

![$Z$ Posterior mean for 4 columns](img/complex/Z_k4.pdf){ id=zc4 height=60% }

Figure \ref{z7} shows the posterior mean for $Z$ when the number of columns is
fixed at 7 (larger than the truth). In this case, the posterior mean learns the
four columns of $Z$ correctly, and the other columns contain no activated
features. This suggests that setting the dimensions of $Z$ to be slightly
higher may allow for the possibility of learning the correct structure for $Z$,
at a slightly more computational cost. (Increasing the number of columns of
$Z$ in MCMC increases the log-computation time by a factor of $\log K$, while
holding the sample-size constant). 

![$Z$ Posterior mean for 7 columns](img/complex/Z_k7.pdf){ id=zc7 height=60% }

### Posterior Estimate of $W$

The $W$ matrix, describes the proportion of observations within each sample
that belong to a certain cell-type (one of $K$ cell types in $Z$).
The true $W$ matrix used in the simulation studies is 

$$
W_{\text{TRUE}} = 
\begin{bmatrix}
0.3 &  0.4 &  0.2  & 0.1 \\
0.1 &  0.7 &  0.1  & 0.1 \\
0.2 &  0.3 &  0.3  & 0.2 \\
\end{bmatrix}.
$$

The interpretation of $W_{ik}$ is the proportion of observations in sample $i$
belonging to cell-type $k$.

The posterior mean of the $W$ matrix for which $K=3$ is
$$
\hat{W}_3 =
\begin{bmatrix}
0.298 & 0.599 & 0.102\\
0.098 & 0.801 & 0.099\\
0.203 & 0.598 & 0.197\\
\end{bmatrix}.
$$
Notice that in the posterior, since there are fewer columns of $W$ than that in
the truth, the proportions of the second and third column in $W_{\text{TRUE}}$
are aggregated into the second column of $\hat W_3$.

The posterior mean of the $W$ matrix for which $K=4$ is
$$
\hat{W}_4 =
\begin{bmatrix}
0.297 & 0.401 & 0.198 & 0.102 \\
0.098 & 0.699 & 0.102 & 0.099 \\
0.203 & 0.305 & 0.294 & 0.197 \\
\end{bmatrix}.
$$
A PERFECT MATCH.


The posterior mean of the $W$ matrix for which $K=7$ is
$$
\hat{W}_7 =
\begin{bmatrix}
 0.297 & 0.401 & 0.198 & 0.102 & 0.00 & 0.00 & 0.00 \\
 0.098 & 0.699 & 0.102 & 0.099 & 0.00 & 0.00 & 0.00 \\
 0.204 & 0.304 & 0.293 & 0.197 & 0.00 & 0.00 & 0.00 \\
\end{bmatrix}
$$
The proportions for the first four column are the proportions in
$W_\text{TRUE}$ up to Monte Carlo error. The last three columns have
proportions close to 0.


### Posterior Estimate of $\mu^*$

![$\mu^*$ Posterior mean for 3 columns](img/complex/mus_k3.pdf){ id=mus3 height=60% }

![$\mu^*$ Posterior mean for 4 columns](img/complex/mus_k4.pdf){ id=mus4 height=60% }

![$\mu^*$ Posterior mean for 7 columns](img/complex/mus_k7.pdf){ id=mus7 height=60% }
