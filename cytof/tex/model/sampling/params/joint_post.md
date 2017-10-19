Let $\bm\theta = (\bm{\theta_1, \theta_2})$, where

- $\theta_1=(\bm{\psi, \tau^2, \sigma^2, \pi})$ are the parameters
  that do not depend on $K$, and
- $\theta_2=(\bm{\mus, v, h, \lambda, w, e})$ are the parameters
  that depend on $K$.

$$
\begin{split}
p(\bm\theta \mid K, \y, \alpha) \propto& \bc{\prod_{i=1}^I 
p(\sigma_i^2) p(\bm{w_i})
\prod_{n=1}^{N_i} p(\lambda_{i,n}\mid \bm {w_i})  \prod_{j=1}^J p(y_{inj} \mid 
\mus_{j,\lambda_{i,n}} , \sigma^2_i, e_{inj}) } \\
&\prod_{j=1}^J p(\tau_j^2) p(\psi_j) \prod_{j=1,k=1}^{J,K}  
%p_{z_{jk}}(\mu^*_{jk} \mid \psi_j, \tau_j^2) 
p(\mus_{jk} \mid \psi_j, \tau_j^2, z_{jk}) 
\prod_{k=1}^Kp(v_k)p(\h_k)\\
%
&\prod_{i=1,j=1}^{I,J} p(\pi_{ij} \mid c_j, d)
\prod_{j=1}^J p(c_j) p(d)\times\\
%
&
\prod_{i=1,n=1,j=1}^{I,N_i,J} p(e_{inj} \mid z_{j,\lin}=0)\\
\end{split}
$$

Note that here, $K$ and $\alpha$ are fixed.

