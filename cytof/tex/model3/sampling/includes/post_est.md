Obtaining posterior estimates and quantifying uncertainty for $Z$, $W$, and
$\lambda$ can be a challenge since they depend directly on $K$ and are susceptible
to label-switching. Therefore, we describe a way to select point-estimates
for $Z$, $W$, and $\lambda$ from their posterior samples.

Suppose we obtain $B$ samples from the posterior distribution of $\theta$. 
Let $\theta^{(b)}$ denote sample $b$ in that sample for $b \in \bc{1,...,B}$.

Then, for each posterior sample of $Z$ and $W_i$ (i.e. $Z^{(b)}$ and
$W_i^{(b)}$) let $A_i^{(b)}$ be a $J\times J$ adjacency-matrix;

$$
A^{(b)}_{i,j,j'} = \sum_{k=1}^K W^{(b)}_{i,k} \Ind{Z^{(b)}_{j,k} = 1}
\Ind{Z^{(b)}_{j',k} = 1}.
$$

Then, compute the mean adjacency-matrix as $\bar A_i =
\sum_{b=1}^B A_i^{(b)} / B$. The posterior estimate for $\bm Z_i$ is then 

$$
\hat{\bm Z}_i = \text{argmin}_{\bm Z} \sum_{j,j'} (A_{i,j,j'}^{(b)} - \bar A_{i,j,j'})^2).
$$

We search for such $\hat \Z_i$ using the Monte Carlo method. Suppose $\hat{\bm
Z}_i = \bm Z^{(b)}$.  We then let $\widehat{\bm W}_i = \bm W_i^{(b)}$, and 
$\hat{\bm \lambda}_i = \bm \lambda_i^{(b)}$.

<!-- Uncertainty? TODO 
But I think one way we can quantify uncertainty would be to compute (Z_i^\alpha, W_i^\alpha) where \alpha \in (0,1) are like "quantiles". i.e.
Z_i^\alpha = Z_i^{(\text{Quantile}(\alpha, A_i^{(b)} - \bar A_i))}
W_i^\alpha = W_i^{(\text{Quantile}(\alpha, A_i^{(b)} - \bar A_i))}
Consequently, Z_i^0 = \hat Z_i and Z_i^1 will be "the worst" estimate for Z, which is Z_i^{(\text{argmax}_b(A_i^{(b)} - A_i)^2)}. Hence we can capture our uncertainty by looking at something like Z_i^{95\%} and W_i^{95\%}
For clarity, this is not the alpha in the model for the IBP. I just used alpha because it is the conventional Greek letter for confidence intervals
-->
