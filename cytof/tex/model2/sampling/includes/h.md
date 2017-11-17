The prior for $\h_k$ is $\h_k \sim \N_J(0, \Gamma)$.
We can analytically compute the conditional distribution 
$h_{j,k} \mid \h_{-j,k}$, which is 

$$
h_{jk}  \mid \h_{-j,k} \sim \N(m_j, S^2_j),
$$

where

$$
\begin{cases}
m_j &= \bm G_{j,-j} \bm G_{-j,-j}^{-1}(\h_{-j,k})\\
S_j^2 &= \bm G_{j,j} - \bm G_{j,-j}\bm G_{-j,-j}^{-1}\bm G_{-j,j}\\
\end{cases}
$$

and the notation $\h_{-j,k}$ refers to the vector $h_k$ excluding the 
$j^{th}$ element. Likewise, $\bm G_{-j,k}$ refers to the $k^{th}$ column 
of the matrix $\bm G$ excluding the $j^{th}$ row.

Note that if $\bm G = \I_J$, then $m_j=0$ and $S_j^2 = 1$.

Let $S = \bc{(i,n)\colon \lin=k}$.

\begin{align*}
p(h_{jk} \mid \y, \rest)  &\propto p(h_{jk})
\end{align*}

Note that $\forall (i,n) \in S$, $\mu_{inj} = \mus_{ijZ_{jk}}$ and 
$\gamma_{inj} = \gamma^*_{ijZ_{jk}}$.
