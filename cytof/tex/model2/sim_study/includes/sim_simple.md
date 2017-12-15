A first simulation study was conducted to investigate how our model 
performs for simulated data (where the true value of the parameters are known)
which has sample sizes and distributions similar to a real data-set
(CB CYTOF data).

We simulate data so that

- $N_i$ is on the order of 10000's
- $\mu_{zij}^*$ is reasonably far away from 0
- the latent feature matrix $Z$ is "simple" (columns are linearly independent)
- the true number of latent features is 4

The MCMC is run for a sufficiently long time, and the dimensions of $Z$ are fixed
at 2,3,...,7. (i.e. six different models are run for different dimensions of $Z$.)

## Simulated Data

Figures \ref{simple1} to \ref {simple3} show some of the properties of the
simulated data. The number of rows in each of the matrices is in the order of
tens of thousands. Specifically, $N=(20000, 30000, 10000)$. Note that these
are heatmaps of $y_{inj}$ (rather than $\tilde y_{inj}$). Red for positive
values, blue for negative values, and white for missing values.

![Simulated data $Y_1$](img/simple/rawDat001.png){ id=simple1 height=60% }

![Simulated data $Y_2$](img/simple/rawDat002.png){ id=simple2 height=60% }

![Simulated data $Y_3$](img/simple/rawDat003.png){ id=simple3 height=60% }

In real CYTOF data, markers that are not expressed are sometimes recorded as
having negative expression levels due to the mechanics of the measurement
devices. Scientists interpret negative expression levels recorded by machines
as non-expression. Consequently, we need to simulate data that have missing values.
We do so by first generating data from the model, and then with some probability
setting observations to be missing. Observations with lower values have a 
higher chance of becoming missing values. In this simulation, we record
observations as missing using the function in Figure \ref{pmiss}.


![Probability of missing](img/simple/prob_miss.pdf){ id=pmiss height=60% }


## Results

The parameters of greatest interest in this model are $Z$, $W$, and $\mu^*$.
Summaries of the posterior distributions from the simulations for those parameters
will be discussed in this section.

### Posterior Estimate of $Z$

In the current model, we assume the dimensions $K$ of the latent feature
allocation matrix to be known. In addition to understanding how well the model
recovers $Z$ when $K$ is correctly specified, we want to understand how
mis-specifying the dimension ($K$) would affect the model. The following
figures provide some insights to this objective. Recall that in the simulation
truth, there are exactly four latent features. Figure \ref{trueSimpleZ}
displays a simple latent feature matrix that was used in this simulation study.

![A simple $Z$ matrix used for simulation study I.](img/simple/trueZ.pdf){ id=trueSimpleZ height=60% }

Figure \ref{z3} shows the posterior mean for $Z$ when the number of columns is 
fixed at 3 (mis-specified as smaller). In this case, the model learns 3 of the
2 columns of $Z$ correctly. In the first column, we see that of the 8 markers that
are supposed to take on feature 1, one marker is not activated and two markers
are erroneously activated. The effect is similar for when $K$ is mis-specified
as 2.

![$Z$ Posterior mean for 3 columns](img/simple/Z_k3.pdf){ id=z3 height=60% }

Figure \ref{z4} shows the posterior mean for $Z$ when the number of columns is 
fixed at 4 (the truth). In this case, the posterior mean learns two of the four
columns of $Z$ correctly. But by simply changing the random seed in the software
used to implement the algorithm, the true $Z$ matrix is completely recovered. This
suggests that the algorithm is slightly sensitive to the starting values 
of the MCMC. 

![$Z$ Posterior mean for 4 columns](img/simple/Z_k4.pdf){ id=z4 height=60% }

Figure \ref{z7} shows the posterior mean for $Z$ when the number of columns is
fixed at 7 (larger than the truth). In this case, the posterior mean learns the
four columns of $Z$ correctly, and the other columns contain no activated
features. This suggests that setting the dimensions of $Z$ to be slightly
higher may allow for the possibility of learning the correct structure for $Z$,
at a slightly more computational cost. (Increasing the number of columns of
$Z$ in MCMC increases the log-computation time by a factor of $\log K$, while
holding the sample-size constant). 

![$Z$ Posterior mean for 7 columns](img/simple/Z_k7.pdf){ id=z7 height=60% }

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
0.401 & 0.400 & 0.197 \\
0.197 & 0.699 & 0.102 \\
0.402 & 0.304 & 0.292 \\
\end{bmatrix}.
$$
Notice that in the posterior, since there are fewer columns of $W$ than that in
the truth, the proportions of the first and fourth column in $W_{\text{TRUE}}$
are aggregated into the first column of $\hat W_3$.

The posterior mean of the $W$ matrix for which $K=4$ is
$$
\hat{W}_4 =
\begin{bmatrix}
0.400 & 0.104 & 0.491 & 0.003 \\
0.699 & 0.099 & 0.004 & 0.196 \\
0.304 & 0.196 & 0.094 & 0.404 \\
\end{bmatrix}.
$$


The posterior mean of the $W$ matrix for which $K=7$ is
$$
\hat{W}_7 =
\begin{bmatrix}
0.298 & 0.400 & 0.196 & 0.10361152 & 0.00 & 0.00 & 0.00 \\
0.098 & 0.700 & 0.102 & 0.09904309 & 0.00 & 0.00 & 0.00 \\
0.204 & 0.304 & 0.293 & 0.19727416 & 0.00 & 0.00 & 0.00 \\
\end{bmatrix}
$$
The proportions for the first four column are the proportions in
$W_\text{TRUE}$ up to Monte Carlo error. The last three columns have
proportions close to 0.


### Posterior Estimate of $\mu^*$

The posterior distribution of $\mu^*$ for different choices of $K$ is
summarized in this section. In general, when $Z$ is not recovered in the posterior,
$\mu^*$ will not be recovered. Moreover, when no observations are assigned to
take on a particular $\mu^*_{zij}$ the parameter will simply be sampled from the
prior (see Figures \ref{musSimple3} and \ref{musSimple4}).

![$\mu^*$ Posterior mean vs. true $\mu^*$ for $K=3$](img/simple/mus_k3.pdf){ id=musSimple3 height=60% }

![$\mu^*$ Posterior mean vs. true $\mu^*$ for $K=4$](img/simple/mus_k4.pdf){ id=musSimple4 height=60% }

In the case where $Z$ is recovered correctly, $\mu^*$ can possibly be recovered
correctly. (See Figure \ref{musSimple7}.)

![$\mu^*$ Posterior mean vs. true $\mu^*$ for $K=7$](img/simple/mus_k7.pdf){ id=musSimple7 height=60% }
