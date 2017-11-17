The prior distribution for $v_k$ are $v_k \mid \alpha \ind \Be(\alpha, 1)$, for 
$k = 1,...,K$. So, $p(v_k \mid \alpha) = \alpha v_k^{\alpha-1}$. 

Note that since $Z_{jk}$ depends on $\prod_{l=1}^k v_l$ (i.e. $v_k$ affects 
$Z_{jl}$ for $l \ge k$), we need to include in the computation of the 
full conditional terms for which $\lin\ge k$.

Let $S = \bc{(i,n)\colon \lin\ge k}$.

\begin{align*}
p(v_k \mid \y, \rest) &\propto p(v_k) \prod_{j=1}^J\prod_{(i,n)\in S} p(\y \mid v_k, \rest) \\
&\propto (v_k)^{\alpha-1} \prod_{j=1}^J \prod_{(i,n)\in S}  \bc{\exp\bc{\frac{-(y_{inj}-\mu_{inj})^2}{2(1+\gamma_{inj})\sigma^2_{ij}}} (1+\gamma_{inj})^{-1/2}}
\end{align*}

Note also that $\mus_{ijZ_{jl}}$ and $\gamma^*_{ijZ_{jl}}$ for $l \ge k$ are
functions of $v_k$, and should be computed accordingly. 

\mhLogitSpiel{v_k}{\xi}
