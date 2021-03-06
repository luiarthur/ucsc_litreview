The model and prior specifications are presented in this section.  Note that
the dIBP will be used in the prior specifications.  Some notation which will be
used throughout this paper is first presented.

## Sampling Model

Let $I$ represent the number of samples (number of patients, or number of
chordal blood samples, etc.).  Let $N_i$ represent the number of cells in
sample $i$, where $i = 1,2,...,I$.  Let $J$ represent the number of markers.
Hence, the raw data $\tilde{y}_{inj}$ represent the raw data for sample $i$,
cell $n$, and marker $j$. From a computation perspective, a suitable data
structure for the data could be a list (of length $I$) of matrices of
(variable) dimensions ($N_i \times J$).  Let $c_{ij}$ denote the "cutoff"
values for sample $i$, marker $j$. For a particular cell ($n$) in sample $i$,
a marker expressions level above the cutoff value $c_{ij}$ for sample $i$ and
marker $j$ indicates that marker $j$ is most likely expressed. A marker
expression level below its corresponding cutoff value, indicates the marker is
not expressed.  These cutoff values are provided by the CyTOF instrument to
correct for background measurement noise picked up by the instrument, and are
positively valued. Since the expression levels for a marker depends on the
number of metals detected in a reading, and the amount of metal ions present
can vary greatly by sample and marker, a different cutoff value is assumed for
each sample and marker combination.

Let $\tilde{y}_{inj}$ be the expression level for sample $i$, cell $n$, marker
$j$ as measured by the CyTOF instrument. Intuitively, expression levels should
only take on positive values and higher values should correspond to higher
probabilities of expression. But due to the precision of the machine, negative
values can be recorded. In such cases, the values are truncated instead as 0
(by scientists) and can be thought of as missing as the expression levels were
so low that they could not be measured. In our modeling, rather than discarding
these values, we can treat them as missing values due to the precision of the
machinery. Specifically, these values can be treated as missing and known to
take on small (negative) values. 

We transform the data so that $y_{inj} = \log\p{\frac{\tilde{y}_{inj}}{c_{ij}}}$.
Notice that if $\tilde{y}_{inj} \le 0$, this quantity is undefined. We consequently
treat these values as missing and we define the missingness indicator
$$
m_{inj} = \begin{cases}
  %0, & \text{if } \log\p{\frac{\tilde{y}_{inj}}{c_{ij}}} < -\infty \\
  0, & \text{if } \tilde{y}_{inj} = 0 \\
  1, & \text{otherwise.}
\end{cases}
$$

That is, $m_{inj}=1$ indicates that the expression level **is missing** for
sample $i$, cell $n$, marker $j$.  Note that under this transformation (1) the
data have infinite support. (2) $y_{inj} = 0$ has a special meaning, which is
that the data take on the same value as the cutoff.  Consequently, $y_{inj} >
0$ means that the data take on values greater than the cutoff, etc. (3)
$y_{inj}$ for which $\tilde{y}_{inj} = 0$ are regarded as missing values, and are 
treated as random variables to be imputed.



Based on the notation presented above, we now present the sampling
distribution.

\begin{align}
  m_{inj} \mid p_{inj}, y_{inj} &\sim \Bern(p_{inj}) \nonumber \\
  %\logit(p_{inj}) &:= \beta_{0ij} - \beta_{1j}~y_{inj} \nonumber \\
  \logit(p_{inj}) &:= \begin{cases}
  \beta_{0ij} - \beta_{1j}(y_{inj}-c_0)^2, & \text{if } y_{inj} < c_0\nonumber \\
  \beta_{0ij} - \beta_{1j}x_j\sqrt{y_{inj}-c_0}, & \text{otherwise} \nonumber \\
  \end{cases}\\
  \label{eq:link}
  \\
  y_{inj} \mid \mu_{inj}, \gamma_{inj}, \sigma^2_{ij}, \bm Z, \lin
  &\sim \N(\mu_{inj}, (\gamma_{inj}+1) \sigma^2_{ij}) \nonumber \\
  \mu_{inj} &:= \mu^*_{Z_{j\lin}ij} \nonumber\\
  \gamma_{inj} &:= \gamma_{Z_{j\lin}ij}^*
  \label{eq:model}
\end{align}

<!-- DONE
{\tt  $ \logit(p_{inj}) = \beta_{0ij} - \beta_{1j}~y_{inj}$ What does this mean? Explain.

Your $Z$ has not been formally introduced yet.  Your $\lambda_{in}$ is not introduced yet. We augment the mixture model (which you haven't explained) by introducing the latent cell type indicator.  

We discussed cell types earlier.  How are cell types related to the parameters in the sampling distribution?

What does $\gamma_{inj}$ do?
}

-->

In the first line, we model the probability of missing as a function of the
data.  Specifically, we want a higher probability of missingness at an
empirically determined value $c_0$, computed to be at the center of the
observed negative values. We again empirically choose $x_j$ for each marker and
strong priors for $\beta_{0ij}$ and $\beta_{1j}$ such that the probability of
missing decreases as the expression levels $y_{inj}$ are away from $c_0$. 
Outside the range of observed negative expression levels for marker $j$ in
sample $i$, we desire a prior probability of missing to be near 0. This
facilitates sampling imputed expression levels around the observed negative
values. We use a logit link function to relate the probability of missing 
to the parameters $\beta$ and  $x$ and the data $y$.
<!--
associated with lower expression levels. We therefore model the probability of
missing $p_{inj}$ with a logistic function of the data $y_{inj}$. An intercept
term for each sample and marker and a slope term for each marker are included.
In addition, we constrain the slope terms to have only positive support to
reflect that lower expression levels are more likely to be missing.
-->

I will now explain the other parameters in the model introduced in
$(\ref{eq:model})$.  Each observed expression level in sample $i$ for marker
$j$ is believed to be distributed Normally centered at some value $\mu^*_{1ij}$
(which has positive support) if the marker is expressed, or $\mu^*_{0ij}$
(which has negative support) if the marker is not expressed. Likewise, their
variances are $\sigma_{ij}$ if the marker is expressed, or
$(1+\gamma^*_{0ij})\sigma^2_{ij}$ (for some positive $\gamma^*_{0ij}$) if the
marker is not expressed. $\bm Z$ which is a $J\times K$ binary matrix is a
latent binary matrix where $Z_{jk} = 1$ indicates that marker $j$ is active in
some cell-type $k$. $\lambda_{in}$ is the cell-type for cell $n$ in sample $i$.
Note that the total possible number of cell-types is $2^J$, but as mentioned
previously, we do not enumerate all cell-types but simply learn the most
prevalent cell-types. Therefore, $\lambda_{in}$ takes on only a finite number
of (contiguous) positive integer values.


Let $\btheta$ represent all parameters (discussed in the next section).
Let $\y$ represent $y_{inj} ~ \forall(i,n,j)$.
Let $\m$ represent $m_{inj} ~ \forall(i,n,j)$.
The resulting **likelihood** is as follows:

\begin{align*}
\mathcal{L} = p(\y, \m \mid \btheta) &= p(\m \mid \y) p(\y \mid \btheta) \\
&= \prod_{i,n,j} p(m_{inj} \mid y_{inj}, \btheta) p(y_{inj} \mid \btheta) \\
&= \prod_{i,n,j} \bc{
  p_{inj}^{m_{inj}} (1-p_{inj})^{1-m_{inj}} \times 
   \frac{1}{\sqrt{2\pi(\gamma_{inj}+1)\sigma^2_{ij}}} \exp\bc{-\frac{(y_{inj}-\mu_{inj})^2}{2(\gamma_{inj}+1)\sigma^2_{ij}}}
}
\end{align*}

The model is fully specified after priors are placed on all unknown parameters.

## Prior Distributions for Model Parameters

<!-- DONE
- [x] Please explain each of the priors e.g. what does each parameter mean? 
    - what $\beta_{ij}$ means? Why do we choose the priors?
    - Why Normal− for $\psi_0$?
    - Why do we have $\mu^*_{0ij}$, not $\mu^*_{kij}$?
    - Include texts and references when they are needed.
- [x] Instead of putting all in one gigantic equation, we may explain one by one.
- [x] Please use letters for fixed hyper-parameters.
- [x] We can explain how we calibrate the priors (how to specify the fixed hyper-parameters) in the Simulation section.
-->

The specific prior distributions for all model parameters are included here.
The first set of parameters relate to the missing-data mechanism. The
parameters that appear in the link function are $\beta_{1j}$ and $\beta_{0ij}$.
Their interpretation have already been explained in the previous section. An
additional parameter $\bar\beta_{0j}$ is used to model the mean of the
$\beta_{0ij}$. This modeling choice is a result markers yielding similar
expression levels across samples and allows for borrowing of information across
different samples to estimate $\beta_{0ij}$. $\beta_{1j}$ is modeled with a
gamma distribution because marker expression levels are more likely to be
recorded as missing when their values are extremely small, due to the
measurement devices. The prior mean of $\bar\beta_{0j}$ is determined
empirically from the data. One way to do this is to first compute the mean of
the negative expression levels for markers across each sample, then solve for
$\beta_{0ij}$ using the link function in (\ref{eq:link}). The prior variances
$s_\beta^2$ and $s^2_{\bar\beta}$ should be small. Such strong priors will ensure
the imputed missing expression values will not inflate parameters such as
$\sigma_{ij}^2$ and $\gamma_{0ij}$ by taking on extremely small values.

\begin{align*}
%\beta_{1j} &\sim \G(90, 30) ~~~~ \text{(mean=3, var=0.1)} \\
\beta_{1j} &\sim \G(a_{\beta_1}, b_{\beta_1}) ~~~~ \text{(mean=$a_{\beta_1}/b_{\beta_1}$)} \\
%\beta_{0ij} \mid \bar\beta_{0j} &\sim \N(\bar\beta_{0j}, \text{var}=0.1) \\
\beta_{0ij} \mid \bar\beta_{0j} &\sim \N(\bar\beta_{0j}, \text{var}=s^2_\beta) \\
%\bar\beta_{0j} &\sim \N(-11, \text{var}=0.1) \\
\bar\beta_{0j} &\sim \N(m_{\bar\beta}, \text{var}=s^2_{\bar\beta}) \\
\end{align*}

The next group of parameters appear in the likelihood. They have also been
discussed in the previous section. One important note here is that we use 
truncated Normal distributions as prior distributions for $\mus_{0ij}$ and
$\mus_{1ij}$. This is to account for the constraint that $\mus_{0ij}$ must
take on negative values, and $\mus_{1ij}$ must take on positive values.
The hyperparameters for $\mus_{0ij}$ and $\mus_{1ij}$ will be learned 
using priors as well.
\begin{align*}
\gamma_{1ij}^* &:= 0 \\
%\gamma_{0ij}^* &\sim \IG(6, 10) ~~~~ \text{(mean=2, var=1)} \\
\gamma_{0ij}^* &\sim \IG(a_\gamma, b_\gamma) ~~~~ \text{(mean=$b_\gamma / (a_\gamma-1)$)} \\
%\sigma^2_{ij} &\sim \IG(2, 1) ~~~~ \text{(mean=1, var=$\infty$)} \\
\sigma^2_{ij} &\sim \IG(a_\sigma, b_\sigma) \\
\mus_{0ij} \mid \psi_0, \tau^2_0 &\sim \N_-(\psi_0, \tau^2_0) \\
\mus_{1ij} \mid \psi_1, \tau^2_1 &\sim \N_+(\psi_1, \tau^2_1) \\
\end{align*}

This group of hyperparameters specify the prior mean and variance
for $\mus_{0ij}$ and $\mus_{1ij}$. Note that the prior means ($\psi$) take on a 
truncated Normal priors again, which accounts for the constraint that
$\mus_{0ij}$ must take on negative values, and $\mus_{1ij}$ must take on
positive values. The prior variances $(\tau^2_0, \tau^2_1)$ for
$(\mus_{0ij},\mus_{1ij})$ have inverse-gamma prior distributions. 
We can choose reasonable hyperparameters for the priors empirically. 
A bulk of the data are centered around 2 and -2. So, one choice of $m_0$ and
$m_1$ could be (-2,2). The variance $\tau^2_z$ models the spread of the centers
$\mus_{zij}$ across samples and markers (for $z=0,1$), which can be determined
empirically, and used to determine $(a_\tau, b_\tau)$.

\begin{align*}
%\psi_{0} &\sim \N_-(-3, 4) \\
%\psi_{1} &\sim \N_+(3, 4) \\
\psi_{0} &\sim \N_-(m_0, s^2_0) \\
\psi_{1} &\sim \N_+(m_1, s^2_1) \\
%\tau^2_{0} &\sim \IG(2, 1) \\
%\tau^2_{1} &\sim \IG(2, 1) \\
\tau^2_{0} &\sim \IG(a_{\tau_0}, b_{\tau_0}) \\
\tau^2_{1} &\sim \IG(a_{\tau_1}, b_{\tau_1}) \\
\end{align*}

The parameters $v$ and $H$ determine the latent binary feature matrix $Z$.  As
discussed in the previous section, $Z$ is distributed as a dependent IBP with
parameter $\alpha=1$.

\begin{align*}
v_k \mid \alpha &\sim \Be(\alpha=1, 1) \\
\pi_k &:= \prod_{l=1}^k v_l \\
\h_k &\sim \N(\bm{0}, \bm G=\I_J) \\
Z_{jk} \mid h_{jk}, v_{1,...,k} &:=
\Ind{\pi_k > \Phi\p{\frac{h_{jk} - 0}{\sqrt{G_{jj}}}}} \\
\end{align*}

The cell-type indicator $\lambda_{in}$ is distributed as a categorical
distribution. Given a probability vector $\bm W_i$, which sums to 1, 
the probability that $\lambda_{in}$ takes on cell-type $k$ is $W_{ik}$.
$\bm W_i$ is modeled with a Dirichlet distribution, with parameters 
$1/K$ where $K$ (which may be random) is the length of $\bm W_i$.

$$
\begin{split}
p(\lin=k \mid \bm W_i) &= W_{ik} \\
\bm W_{i} &\sim \Dir(1/K, ..., 1/K) \\
\end{split}
$$


## Posterior Computation
Standard MCMC techniques like Gibbs sampling and the Metropolis method are used
to sample from the posterior distribution of the parameters. In each of the
simulations, 2000 samples were gathered after a burn-in of 2000 iterations. The
MCMC was thinned by a factor of 5. (i.e. only one of every 5 samples after the
burn-in are kept.)

Gibbs sampling is a way to sample from the full posterior of the parameters of
a probabilistic model. It involves sequentially sampling from the full
conditional distribution of each parameter iteratively. This procedure is
continued until sufficient (independent) samples from the joint posterior are
obtained. This may require some burn-in period as the Markov chain may take
some time to "converge" to a region where it is sampling correctly from the 
joint posterior.

Most of the computation needed for sampling from the full conditionals of each
parameter is straight-forward. Though, some care needs to be taken to sample
$K$, which determines the dimensions and possible values for the parameters
$\bm\theta_1=(Z, v, H, W, \lambda)$. So, we introduce an method for sampling
$K$. The idea is to iteratively (1) sample $(\bm\theta_1, K)$ jointly using a
small "training set" to learn a prior for $\btheta$, and (2) sample
$(\bm\theta_1 \mid K)$ based on the most recent $K$ using a large subset of the
entire data (which we will call the "testing set").

Moreover, when working with the likelihood, we will marginalize over $\lambda$
so as to avoid the need to impute its value in the "testing set". The details
will be placed in the appendix. 

Another item that needs special treatment is the summary of the posterior
distribution of parameters that have variable dimensions ($\bm\theta_1$).
Particularly, inference on $Z$ and $W$ are of greatest interest. We use
a method based on sequentially-allocated latent structure
optimization (SALSO) by @salso.

In SALSO, a point estimate is for a binary feature matrix is obtained by
finding a $\hat{Z}$ that minimizes the expression

\begin{align}
\text{argmin}_Z\sum_{r=1}^J\sum_{c=1}^J(A(Z)_{rc} - \bar{A}_{rc})^2
\label{eq:salso}
\end{align}

where $A(Z)$ is the pairwise allocation matrix corresponding to a binary matrix
$Z$, and $\hat A$ is the pairwise allocation matrix averaged over all posterior
samples of $Z$. Thus in the current application, $A_{rc}$ is the number of
times that marker $r$ and marker $c$ share a feature. We adapted the method
by not using any optimization methods to compute $\hat Z$, but by simply
selecting the $Z$ from the posterior samples of $Z$ that minimizes the
expression in (\ref{eq:salso}). We can similarly get point estimates for $W$
and $\lambda$.  Concretely, if we have $B$ samples from the full posterior and
$Z^{(b)}$ denotes the sample for $Z$ taken at iteration $b \in \bc{1,...,B}$ of
the MCMC, then if $Z^{(b)}$ is the point estimate for $Z$ computing using
SALSO, we can use $(W^{(b)}, \lambda^{(b)})$ as point estimates for
$(W,\lambda)$.




<!-- DONE
- [x] Discuss the posterior computations. You already have some in your section 4.2. Please move them here and elaborate more.
- [x] We will make the number of cell types K random.
- [x] Discuss how we run MCMC with random K.
- [x] Include how to summarize the posterior MCMC samples (which you also explained later). How do we find the posterior estimates of Z, w and other parameters.
-->
