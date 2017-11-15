Sampling can be done via Gibbs sampling by repeatedly updating each parameter
one at a time until convergence. Parameter updates are made by sampling from
it full conditional distribution. Where this cannot be done conveniently, 
a metropolis step will be necessary.

To sample from a distribution which is otherwise difficult to sample from, the
Metropolis-Hastings algorithm can be used. This is particularly useful when
sampling from a full conditional distribution of one of many parameters in an
MCMC based sampling scheme (such as a Gibbs sampler). Say $B$ samples from a
distribution with density $p(\theta)$ is desired, one can do the following:

1. Provide an initial value for the sampler, e.g. $\theta^{(0)}$.
2. Repeat the following steps for $i = 1,...,B$.
3. Sample a new value $\tilde\theta$ for $\theta^{(i)}$ from a proposal 
   distribution $Q(\cdot \mid \theta^{(i-1)})$.
     - Let $q(\tilde\theta \mid \theta)$ be the density of the
       proposal distribution.
4. Compute the "acceptance ratio" to be 
   $$
   \rho=
   \min\bc{1, \frac{p(\tilde\theta)}{p(\theta^{(i-1)})} \Big/ 
              \frac{q(\tilde\theta\mid\theta^{(i-1)})}
                   {q(\theta^{(i-1)}\mid\tilde\theta)}
          }
   $$
5. Set 
   $$
   \theta^{(i)} := 
   \begin{cases}
   \tilde\theta &\text{with probability } \rho \\
   \theta^{(i-1)} &\text{with probability } 1-\rho.
   \end{cases}
   $$

Note that in the case of a symmetric proposal distribution, the 
acceptance ratio simplifies further to be 
$\frac{p(\tilde\theta)}{p(\theta^{(i-1)})}$.

The proposal distribution should be chosen to have the same support
as the parameter. Transforming parameters to have infinite support
can, therefore, be convenient as a Normal proposal distribution
can be used. Moreover, as previously mentioned, the use of symmetric proposal
distributions (such as the Normal distribution) can simplify the 
computation of the acceptance ratio.

Some common parameter transformations are therefore presented here:

1. For parameters bounded between $(0,1)$, a logit-transformation
   may be used.  Specifically, if a random variable $X$ with density $f_X(x)$
   has support in the unit interval, then $Y=\logit(X)=\log\p{\frac{p}{1-p}}$
   will have density 
   $f_Y(y) = f_X\p{\frac{1}{1+\exp(-y)}}\frac{e^{-y}}{(1+e^{-y})^{2}}$.
2. For parameters with support $(0,\infty)$, a log-transformation
   may be used.  Specifically, if a random variable $X$ with density $f_X(x)$
   has positive support, then $Y = \log(X)$ has pdf
   $f_Y(y) = f_X(e^y) e^y$.


