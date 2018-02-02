So far, we have treated the dimensions $K$ of the latent feature matrix $\Z$ as
fixed. This may be limiting as separate models may need to be fit for each
choice of $K$ (via cross-validation), which comes at a great computational
cost. Moreover, learning the number of latent features $K$ is the motivation
for using the IBP (a nonparametric distribution) as a prior for the latent
feature matrix. So we now introduce an algorithm based on MCMC for sampling
$K$. The idea is to iteratively

1. sample $(\bm\theta_1, K)$ jointly using a small "training set" to learn a prior for $\btheta$.
2. sample $(\bm\theta_1 \mid K)$ based on the most recent $K$ using a large subset of the entire data (which we will call the "testing set").

Moreover, when working with the likelihood, we will marginalize over $\lambda$
so as to avoid the need to impute its value in the "testing set". The algorithm
will be expounded upon below. 

### Sampling $(\bm\theta, K \mid \y)$ using Small Training Set to Learn Prior for $\btheta$

Let $\y^{TR}$ refer to a (predetermined) randomly selected subset of
observations of the entire data. We will call this the training set.  The size
of this training set should be large enough to contain a representative
subsample of the data. Yet, it should not be excessively large as a larger
training set will lead to greater computation time. The number of rows in
$\y^{TR}$ could be about 50% that of the entire data $\y$. For example, to
ensure that the sample is representative of the data, 50% from each sample $i$
will be taken. Let $\y^{TE}$ refer to the remaining observations. That is, $\y
= \y^{TE} \cup \y^{TR}$. We will call $\y^{TE}$ the testing set.

Let the prior distribution for $K$ be $K \sim \Unif(1, K^{\max})$, where
$K^{\max}$ is some integer **sufficient large** (trial and error, start with
15?).  Also, let $p^\star(\bm\theta_1) = p(\bm\theta_1 \mid \y^{TR}, K)$ be the
posterior distribution of $\bm\theta_1$ given the training set and $K$.  That is,
we learn the prior distribution for $\btheta_1$ from a small training set.

From empirical simulation studies, when the number of observations in the training
set is not large enough and the initial value for $K$ is smaller than the true
dimensions of $Z$, the MCMC is not recurrent and it may not be possible for $K$
to move to the true dimensions of $Z$ or beyond. Hence, we recommend
initializing $Z$ to have a reasonably large number of columns.

The joint posterior for $(\bm\theta_1, K)$ is then

\begin{align*}
p(\theta_1,K \mid \y^{TE}) &\propto p(K)p^\star(\bm\theta_1)
p(\y^{TE} \mid \bm\theta_1, K) \\
%%%
&\propto p(K)
p(\bm\theta_1 \mid K, \y^{TR}) p(\y^{TE} \mid \bm\theta_1, K) \\
%%%
&\propto p(K)
p(\bm\theta_1\mid K) p(\y^{TR} \mid \bm\theta_1, K) p(\y^{TE} \mid \bm\theta_1, K) \\
&\propto p(K, \bm\theta_1)
p(\y^{TR} \mid \bm\theta_1, K) p(\y^{TE} \mid \bm\theta_1, K) \\
&\propto p(K, \bm\theta_1)
p(\y \mid \bm\theta_1, K) \\
\end{align*}

Note that this is the same as the posterior distribution of 
$(\bm\theta_1, K)$ given the entire data.

Simplifying the expression, we get

$$
p(\theta_1,K \mid \y^{TE})
\propto 
p(\bm\theta_1 \mid K, \y^{TR}) p(\y^{TE} \mid \bm\theta_1, K).
$$

Note that $p(K)$ is missing from the expression as it is 
a constant with respect to $K$.

We can sample from the distribution using a Metropolis-Hastings
step. The proposal mechanism is as follows:

1. Propose $\tilde K \mid K \sim$
   $$
   \begin{cases}
   \Unif(K-a, K+a) &\text{ if } a+1 \le K \le K^{\max} -a \\
   \Unif(1, K+a) &\text{ if } K-a < 1 \\
   \Unif(K-a, K^{\max}) &\text{ if } K+a > K^{\max} \\
   \end{cases}
   $$
   That is, draw $\tilde K$ from a discrete uniform 
   distribution centered
   at the previous state $K$, within a neighbourhood of size
   $a$ which is a constant to be tuned, but is constrained
   such that $2a \le K^{\max}$.

   For clarity, the corresponding proposal densities for 
   $\tilde K$ are:

   $$
   \begin{cases}
   q_K(\tilde{K} \mid K) = (2a +1)^{-1} 
   & \text{ if } a+1 \le K \le K^{\max} -a\\
   q_K(\tilde{K} \mid K) = (K+a)^{-1}  
   & \text{ if } K-a < 1 \\
   q_K(\tilde{K} \mid K) = (K^{max} - K+a +1)^{-1} 
   &\text{ if } K+a > K^{\max} \\
   \end{cases}
   $$



2. Given $\tilde K$, we then propose 
   $\tilde{\bm\theta} \mid \tilde K$ with the proposal 
   distribution
   being the prior. To clarify, the prior here refers to the
   posterior distribution of $\bm\theta$ given the smaller
   training data. That is, 
   $q_\theta(\bm\theta) = p(\bm\theta \mid K, \y^{TR})$.
3. We accept the proposed draw $(\tilde K, \bm{\tilde\theta})$
   with probability $\min\bc{1, \Lambda}$ where 
   \begin{align*}
   \Lambda & = 
   \frac{
     p(\tilde K) p^\star(\tilde\btheta) p(\y^{TE} \mid \tilde\btheta, \tilde K)
   }{
     p(K) p^\star(\btheta) p(\y^{TE} \mid \btheta, K)
   }
   \times
   \frac{ %%% PROPOSAL
     q_K(K \mid \tilde K) q_\theta(\btheta \mid K)
   }{
     q_K(\tilde K \mid K) q_\theta(\tilde\btheta \mid \tilde K)
   }
   \\
   \\
   & = 
   \frac{
     p(\tilde K) p^\star(\tilde\btheta) p(\y^{TE} \mid \tilde\btheta, \tilde K)
   }{
     p(K) p^\star(\btheta) p(\y^{TE} \mid \btheta, K)
   }
   \times
   \frac{ %%% PROPOSAL
     q_K(K \mid \tilde K) p^\star(\btheta)
   }{
     q_K(\tilde K \mid K) p^\star(\tilde\btheta)
   }
   \\
   \\
   & = 
   \frac{
     p(\y^{TE} \mid \tilde\btheta, \tilde K)
     ~
     q_K(K \mid \tilde K)
   }{
     p(\y^{TE} \mid \btheta, K)
     ~
     q_K(\tilde K \mid K)
   }.
   \end{align*}

Note that sampling from $(\btheta \mid K, \y^{TR})$ can be done by sampling
from the full conditional of each parameter in $\btheta$. Note that
the steps for sampling from the full conditional of each parameter
in $\btheta$ given $K$ are already provided above. The only modification
needed is that a smaller subset of the data $\y^{TR}$ is used instead of the
entire data $\y$.

Since $K$ can be one of $\bc{1,...,K^{\max}}$. We need to keep $K^{\max}$
separate MCMC chains for $\btheta$ (one for each $K$). Each time a sample from
$\btheta \mid K, \y^{TR}$ is required for a particular $K$, only the 
Markov chain corresponding to that $K$ is updated. In terms of computation, 
note that in this way, the entire Markov chain need not be stored, but only
the most recent element in the chain (the most recent set of parameters
$\btheta$ for each $K$).

Finally, a small *burn-in* period may be necessary to obtain samples from 
$p^\star(\btheta) = p(\btheta \mid K, \y^{TR})$ for each $K$. That is, at the
**very start** of the algorithm, we should run $K$ MCMC chains (one for each
$K$) for to sample from $p(\btheta \mid K, \y^{TR})$ for some number of 
iterations (say 3000). This period acts as a burn-in to aid in collecting
better samples from the distribution.

### Sampling From $\btheta  \mid K, \y^{TE}$

Sampling from $\btheta \mid K, \y^{TE}$ can be done
by sampling from the full conditional of each parameter in $\btheta$ given
a large subset of the data $\y^{TE}$. Again, the steps for sampling from 
the full conditional of each parameter in $\btheta$ given $K$ is provided
previously. 
This time, the only modification needed is that the entire data $\y$ is used.


