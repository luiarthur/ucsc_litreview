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

### Simulated Data

Figure \ref{fig:simpleDat} show some of the properties of the
simulated data. The number of rows in each of the matrices is in the order of
tens of thousands. Specifically, $N=(20000, 30000, 10000)$. Note that these
are heatmaps of $y_{inj}$ (rather than $\tilde y_{inj}$). Red for positive
values, blue for negative values, and white for missing values.

\beginmyfig
![](img/simple/rawDat001.png){ height=30% }
![](img/simple/rawDat001.png){ height=30% }
![](img/simple/rawDat001.png){ height=30% }
\caption{Simulated Data. $Y_1$ (left), $Y_2$ (middle), $Y_3$ (right).}
\label{fig:simpleDat}
\endmyfig


In real CYTOF data, markers that are not expressed are sometimes recorded as
having negative expression levels due to the mechanics of the measurement
devices. Scientists interpret negative expression levels recorded by machines
as non-expression. Consequently, we need to simulate data that have missing values.
We do so by first generating data from the model, and then with some probability
setting observations to be missing. Observations with lower values have a 
higher chance of becoming missing values. In this simulation, we record
observations as missing using the function in Figure \ref{pmiss}. 
The figure contains the simulation truth (in black) and the prior distribution
over the logistic function (implied by the priors on $\beta$). Note that a strong
prior is placed on logistic functions that are steep, and a loose prior is placed
on the location of the logistic function.

![Probability of missing. The black line represents the simulation truth. The thick red dashed line represents the prior median. The thin red dashed line represents the prior mean. The red area is the prior 95% credible interval. ](img/simple/prior_prob_miss.pdf){ id=pmiss height=40% }


### Results

The parameters of greatest interest in this model are $Z$, $W$, and $\mu^*$.
Summaries of the posterior distributions from the simulations for those parameters
will be discussed in this section.

#### Posterior Estimate of $Z$

In the current model, we assume the dimensions $K$ of the latent feature
allocation matrix to be known. In addition to understanding how well the model
recovers $Z$ when $K$ is correctly specified, we want to understand how
mis-specifying the dimension ($K$) would affect the model. The following
figures provide some insights to this objective. Recall that in the simulation
truth, there are exactly four latent features. Figure \ref{trueSimpleZ}
displays a simple latent feature matrix that was used in this simulation study.

![A simple $Z$ matrix used for simulation study I.](img/simple/trueZ.pdf){ id=trueSimpleZ height=40% }

I have summarized the posterior distribution of $Z$ in two ways. The first is
the posterior mean, which is simply the average of all posterior samples of $Z$
from the MCMC. After averaging, the resulting matrix is sorted by column into
its left-ordered form. The other summary statistic for $Z$ is an adaptation
of the sequentially-allocated latent structure optimization (SALSO) by David Dahl. 
In SALSO, a point estimate is obtained by finding a $\hat{Z}$ that minimizes
the expression

$$
\text{argmin}_Z\sum_{r=1}^J\sum_{c=1}^J(A(Z)_{rc} - \bar{A}_{rc})^2,
$$

where $A(Z)$ is the pairwise allocation matrix corresponding to a binary matrix
$Z$, and $\hat A$ is the pairwise allocation matrix averaged over all 
posterior samples of $Z$. The adaptation I have made is I have not used
any optimization methods to compute $\hat Z$. I have simply selected the $Z$ 
from the posterior samples of $Z$ that minimizes the expression above. In this
section, I'll mostly comment on the point-estimate of $Z$ but I have included
the posterior mean as a reference.

Figure \ref{fig:zpoint} (left) shows the point-estimate for $Z$ when the number of
columns is fixed at 3 (mis-specified as smaller). In this case, the model
learns 1 of the 4 columns of $Z$ correctly. One column is duplicated. The
remaining column shows no clear pattern. The effect is similar for when $K$ is
mis-specified as 2.

\beginmyfig
![](img/simple/Z_point_k3.pdf){ height=30% }
![](img/simple/Z_point_k4.pdf){ height=30% }
![](img/simple/Z_point_k7.pdf){ height=30% }
\caption{Posterior point-estimate for $Z$ of 3 columns (left), 4 columns (middle),
and 7 columns (right).}
\label{fig:zpoint}
\endmyfig

Figure \ref{fig:zpoint} (middle) shows the point-estimate for $Z$ when the number of
columns is fixed at 4 (the truth). In this case, the true $Z$ is learned.

Figure \ref{fig:zpoint} (right) shows the point-estimate for $Z$ when the
number of columns is fixed at 7 (larger than the truth). In this case, the four
columns of $Z$ are learned correctly, two of the columns contain no activated
features, and one column contains one active feature. This suggests that
setting the dimensions of $Z$ to be slightly higher may allow for the
possibility of learning the correct structure for $Z$, at a slightly more
computational cost.  (Increasing the number of columns of $Z$ in MCMC increases
the log-computation time by a factor of $\log K$, while holding the sample-size
constant). 

#### Posterior Estimate of $W$

The $W$ matrix, describes the proportion of observations within each sample
that belong to a certain cell-type (one of $K$ cell types in $Z$).
The true $W$ matrix used in the simulation studies is 

$$
W^{\text{TR}} = 
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
\hat{W}_3 = \input{img/simple/W_mean_k3.tex}
$$
The posterior mean is obtained by simple averaging of the posterior samples of
$W$.  Notice that in the posterior, since there are fewer columns of $W$ than
that in the truth, the proportions of the second column of $W^{\text{TR}}$
are now in the first column of $\hat W_3$. The second column of $\hat W_3$
is close to 0. The remaining column takes the remaining proportions.

The posterior mean of the $W$ matrix for which $K=4$ is
$$
\hat{W}_4 = \input{img/simple/W_mean_k4.tex}
$$
which closely resembles the truth (ignoring column ordering).

The posterior mean of the $W$ matrix for which $K=7$ is
$$
\hat{W}_7 = \input{img/simple/W_mean_k7.tex}
$$
Ignoring the column ordering and the columns of zeros, $\hat W_7$ closely
resembles the truth.


#### Posterior Estimate of $\mu^*$

The posterior distribution of $\mu^*$ for different choices of $K$ is
summarized in this section. In general, when $Z$ is not recovered in the
posterior, $\mu^*$ will not be recovered. Moreover, for $z=\bc{0,1}$, when
$\sum_{n=1}^{N_i} \Ind{Z_{j,\lambda_{in}} = z}$ is small, $\mu^*_{zij}$ will
simply be sampled more heavily from the prior.

For example, in Figure \ref{fig:musSimple} (left), we see a lot of uncertainty for
$\mu^*$ which are supposed to be positively-valued. This is due to the
posterior $Z$ matrices lacking active features where they are needed (see
Figure \ref{fig:zpoint}).

In the case where $Z$ is recovered correctly, $\mu^*$ can possibly be recovered
correctly. Figure \ref{fig:musSimple} (middle) shows the posterior distribution of
$\mu^*$ for which $K=4$. The posterior means line up with the truth. The
credible intervals are short due to the number of observations.

Finally, Figure \ref{fig:musSimple} (right) shows the posterior distribution of
$\mu^*$ for which $K=7$. As $Z$ is recovered, the posterior means line up with
the truth.

\beginmyfig
![](img/simple/mus_k3.pdf){ height=32% }
![](img/simple/mus_k4.pdf){ height=32% }
![](img/simple/mus_k7.pdf){ height=32% }
\caption{$\mu^*$ Posterior mean vs. true $\mu^*$ for $K=3$ (left), $K=4$
(middle), and $K=7$ (right). Circles represent the posterior mean. Vertical
lines represent the 95\% credible intervals.  Triangles also represent the
posterior mean, but for $\mu_{zij}$ that have fewer than 30 corresponding
$Z_{j,\lambda_{in}}$. They should have large intervals.}
\label{fig:musSimple}
\endmyfig

