The prior for $\lin$ is $p(\lin = k \mid \bm W_i) = W_{ik}$.

\begin{align*}
p(\lin=k\mid \y,\rest) &\propto p(\lin=k) ~ p(\y \mid \lin=k, \rest) \\
&\propto W_{ik}
\prod_{j=1}^J 
\p{
  \sum_{\ell=1}^{L^{Z_{jk}}} \eta^{Z_{jk}}_{ij\ell} \cdot
  \N(y_{inj} \mid 
  \mus_{Z_{jk}\ell}, \sss_{Z_{jk}i\ell})
}\\
\end{align*}

The normalizing constant is obtained by summing the last expression over 
$k = 1,...,K$. Moreover, since $k$ is discrete, a Gibbs update can be done
on $\lin$.
