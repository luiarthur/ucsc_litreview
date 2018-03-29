The prior distribution for $v_k$ are $v_k \mid \alpha \ind \Be(\alpha/K, 1)$, for 
$k = 1,...,K$. So, $p(v_k \mid \alpha) = \alpha v_k^{\alpha/K-1}$. 

Let $S = \bc{(i,n)\colon \lin = k}$.

\begin{align*}
p(v_k \mid \y, \rest) &\propto p(v_k) \prod_{j=1}^J\prod_{(i,n)\in S} p(\y \mid v_k, \rest) \\
&\propto (v_k)^{\alpha-1} \prod_{j=1}^J \prod_{(i,n)\in S}
\sum_{l=1}^{L^{Z_{jk}}} \eta^{Z_{jk}}_{ijl} \cdot
\N(y_{inj} \mid \mus_{Z_{jk}l}, \sss_{Z_{jk}il})
\end{align*}

\mhLogitSpiel{v_k}{\xi}

Note also that $\mus_{Z_{jk}l}$ and $\sss_{Z_{jk}il}$ are functions of $v_k$,
and should be computed accordingly. Moreover, we will only recompute the
likelihood (in the metropolis acceptance ratio) when $Z_{jk}$ becomes
different.

