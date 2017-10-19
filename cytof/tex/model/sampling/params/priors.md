- $\mus_{jk}$:
$$\begin{cases}
p(\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk}=1) ~~&=~~ 
\pmugt[\mus_{jk} > \log(2)]{k} \\
%
p(\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk}=0) ~~&=~~ 
\pmult[\mus_{jk} < \log(2)]{k} \\
\end{cases}
$$
- $\psi_j$: 
    $$\psi_j \sim \N(m_\psi, s^2_\psi)$$
- $\tau^2_j$: 
    $$\tau^2_j \sim \IG(a_\tau, b_\tau)$$
- $\pi_{ij}$: 
    $$
    \begin{split}
    \pi_{ij} \mid c_j, d &\sim \Be^\star(c_j, d) \\
    \logit(c_j) &\sim \N(0,s^2_c) \\
    \log(d) &\sim \N(m_d,s^2_d) \\
    \end{split}
    $$
    - where $\Be^*(c,d)$ is a Beta distribution parameterized with a mean 
      parameter $c$ and a dispersion parameter $d$ such that 
      $\Be^*(c,d) = \Be(cd, (1-c)d)$, for some $c\in(0,1)$ and $d > 0$.
- $\sigma^2_i$:
    $$ \sigma^2_i \sim \IG(a_\sigma, b_\sigma)$$
- $v_l$:
    $$v_l \mid \alpha \sim \Be(\alpha, 1)$$
- $\h_k$:
    $$\h_k \sim \N(\bm{0},\Gamma)$$
- $\lin\mid\w_i$:
    $$p(\lin=k\mid\w_{i}) = w_{ik}$$
- $\w_i$:
    $$\w_i \sim \Dir(a_1,...,a_K)$$


