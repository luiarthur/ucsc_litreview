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
p(h_{jk} \mid \y, \rest)  &\propto p(h_{jk}) \prod_{(i,n) \in S} p(y_{inj} \mid h_{jk}, \rest) \\
%
&\propto
\exp\bc{\frac{-(h_{jk} - m_j)^2}{2S_j^2}}
\prod_{(i,n)\in S} \bc{\exp\bc{\frac{-(y_{inj}-\mu_{inj})^2}{2(1+\gamma_{inj})\sigma^2_{ij}}} (1+\gamma_{inj})^{-1/2}}
\end{align*}

Note that $\forall (i,n) \in S$, $\mu_{inj} = \mus_{ijZ_{jk}}$ and 
$\gamma_{inj} = \gamma^*_{ijZ_{jk}}$. Note also that both $\mus_{ijZ_{jk}}$ and 
$\gamma^*_{ijZ_{jk}}$ are functions of $h_{jk}$, and should be computed
accordingly. 

\mhSpiel{h_{jk}}
