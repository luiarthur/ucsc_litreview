The prior for $\lin$ is $p(\lin = k \mid \bm W_i) = W_{ik}$.

\begin{align*}
p(\lin=k\mid \y,\rest) &\propto p(\lin=k) ~ p(\y \mid \lin=k, \rest) \\
&\propto W_{ik} \prod_{j=1}^J p(y_{inj} \mid \mus_{Z_{jk}ij}, \gamma^*_{Z_{jk}ij}, \rest) \\
%
&\propto W_{ik} \p{\prod_{1=j}^J (1+\gamma^*_{Z_{jk}ij})^{-1/2}}
\exp\bc{-\sum_{j=1}^J \frac{(y_{inj} - \mus_{Z_{jk}ij})^2}{2\sigma^2_{ij}(1+\gamma^*_{Z_{jk}ij})}}
\end{align*}

The normalizing constant is obtained by summing the last expression over 
$k = 1,...,K$. Moreover, since $k$ is discrete, a Gibbs update can be done
on $\lin$.
