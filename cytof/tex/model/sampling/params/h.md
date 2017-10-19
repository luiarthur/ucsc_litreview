## Full Conditional for $h$ (II)
The prior for $\h_k$ is $\h_k \sim \N_J(0, \Gamma)$.
Using Normal theory, we can find the conditional distribution 
$h_{j,k} \mid \h_{-j,k}$, which is 

$$
h_{jk}  \mid \h_{-j,k} \sim \N(m_j, S^2_j),
$$

where

$$
\begin{cases}
m_j &= \Gamma_{j,-j}\Gamma_{-j,-j}^{-1}(\h_{-j,k})\\
S_j^2 &= \Gamma_{j,j} - \Gamma_{j,-j}\Gamma_{-j,-j}^{-1}\Gamma_{-j,j}\\
\end{cases}
$$

and the notation $\h_{-j,k}$ refers to the vector $h_k$ excluding the element in
the $j^{th}$ position. Likewise, $\Gamma_{-j,k}$ refers to the $k^{th}$ column 
of the matrix $\Gamma$ excluding the $j^{th}$ row.

Note again that if $\mus_{jk}>0$, then $z_{jk}=1$ by definition, which in turn
affects $\h_k$. So, we will jointly update $\mus_{jk}$ and $\h_k$. 

The full conditional for $(\h_{jk}, \mus_{jk})$ is:
$$
\begin{split}
&p(h_{jk}, \mus_{jk} \mid \h_{-j,k}, \y, \rest) 
\\
\\
\propto~&
p(h_{jk}\mid \h_{-j,k}) \times
p(\mus_{jk}\mid\psi_j, \tau^2_j, z_{jk}) \times \\
&
\prod_{i=1}^I \prod_{n=1}^{N_i}
\bc{
  p(e_{inj} \mid z_{j,\lin}, \pi_{ij})^{\Ind{\lin = k,~z_{j,\lin}=0}}
  p(y_{inj} \mid \mus_{jk}, \sigma_i^2, e_{inj}) ^ {\Ind{\lin=k}}
}
\\
\\
%%%%%%%%
\propto~&
\Npdfc{h_{jk}}{m_j}{S_j^2}
\times \\
& \pmugtc{k} \pmultc{k} \times \\
&
\prod_{(i,n):\lin=k}
\bc{
  \p{
    \pi_{ij}^{e_{inj}}
    \p{1-\pi_{ij}}^{1-e_{inj}}
  }^{\Ind{z_{j,\lin}=0}}
  \times
  \likezeroc{k} 
}\\
\end{split}
$$

Since the full conditional cannot be sampled from directly, a metropolis update
is required. Let $Q_2$ be the proposal distribution. The proposal mechanism
will be as follows:

1. Given the current state $(h_{jk}, \mus_{jk})$,
   sample a proposed state $\tilde h_{jk}$ from $\N(\cdot \mid h_{jk}, \Sigma_h)$ 
   for $h_{jk}$, where $\Sigma_h$ is some covariance matrix to be tuned.
2. Compute the new $\tilde z_{jk}$ (from the updated $h_{jk}$).
3. If $z_{jk}$ is unchanged, then the proposed state for $\mus_{jk}$ is simply
   its current state. Otherwise, the proposed state is 
   $\tmus_{jk} \sim \N(\cdot \mid \psi_j, \tau_j^2, \tilde z_{jk})$ 
4. Compute the proposal density as 
   $$
   \begin{split}
   q_2(\tilde h_{jk}, \tmus_{jk} \mid h_{jk}, \mus_{jk})
   &\propto~
   \Npdfc{\tilde h_{jk}}{h_{jk}}{\Sigma_h} \times
   p(\tmus_{jk} \mid \psi_j, \tau_j^2, \tilde z_{jk})^{\Ind{\tilde z_{jk} \ne z_{jk}}}
   \\
   \end{split}
   $$
5. The proposed state $(\tilde h_{jk}, \tmus_{jk})$ will be
   accepted with probability 
   $$ \min\bc{1, \Lambda }, $$ where
   \begin{align*}
   \Lambda &=
   \frac{
     p(\tilde h_{jk}, \tmus_{jk} \mid \y, \rest) 
     \times
     q_2( h_{jk}, \mus_{jk} \mid 
     \tilde h_{jk}, \tmus_{jk}) 
   }{
     p(h_{jk}, \mus_{jk} \mid \y, \rest) 
     \times
     q_2( \tilde h_{jk}, \tmus_{jk} \mid 
     h_{jk}, \mus_{jk} )
   }\\
   %%%%%%%%%
   &= \frac{
     p(\tilde  h_{jk} \mid \tilde \h_{-jk})
     p(\tmus_{jk} \mid \psi_j, \tau^2_j, \tilde z_{jk})
   }{
     p(h_{jk} \mid \h_{-jk})
     p(\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk})
   }
   \times 
   \\ &~~~~
   \prod_{(i,n,j):\lin=k}
   \frac{
     %p(e_{inj} \mid \tilde z_{j,\lin}, \pi_{ij})^{1-\tilde z_{j,\lin}}
     %p(y_{inj} \mid \tmus_{jk}, \sigma_i^2, e_{inj})
     p(y_{inj} \mid \tmus_{jk}, \sigma_i^2, \pi_{ij}, \tilde z_{j,\lin})
   }{
     %p(e_{inj} \mid z_{j,\lin}, \pi_{ij})^{1-z_{j,\lin}}
     %p(y_{inj} \mid \mus_{jk}, \sigma_i^2, e_{inj})
     p(y_{inj} \mid \mus_{jk}, \sigma_i^2, \pi_{ij}, z_{j,\lin})
   }
   \times
   \\ &~~~~
   \frac{
     \Npdf{h_{jk}}{\tilde h_{jk}}{\Sigma_h}
   }{
     \Npdf{\tilde h_{jk}}{h_{jk}}{\Sigma_h}
   }
   \bc{
   \frac{
     p(\mus_{jk} \mid \psi_j, \tau_j^2, z_{jk})
   }{
     p(\tmus_{jk} \mid \psi_j, \tau_j^2, \tilde z_{jk})
   }
   }^{\Ind{z_{jk}\ne \tilde z_{jk}}}
   \\
   \\ 
   %%%%%%%%%%%%%%%
   %%%% CRUX !!!
   &= \frac{
     p(\tilde  h_{jk} \mid \tilde \h_{-jk})
   }{
     p(h_{jk} \mid \h_{-jk})
   }
   \times 
   \prod_{\bc{(i,n,j):\lin=k}}
   \frac{
     p(y_{inj} \mid \tmus_{jk}, \sigma_i^2, \pi_{ij}, \tilde z_{j,\lin})
   }{
     p(y_{inj} \mid \mus_{jk}, \sigma_i^2, \pi_{ij}, z_{j,\lin})
   }
   \\
   \\
   %%%%%%%%%%%%%%%
   &=
   \exp\bc{
     -\frac{(\tilde h_{jk} - m_j)^2 - (h_{jk} - m_j)^2}
           {2 S_j}
   }
   \times \\
   &\prod_{\bc{(i,n,j):\lin=k,~\tilde z_{j,\lin} \ne z_{j,\lin}}}
   \frac{
     p(y_{inj} \mid \tmus_{jk}, \sigma_i^2, \pi_{ij}, \tilde z_{j,\lin})
   }{
     p(y_{inj} \mid \mus_{jk}, \sigma_i^2, \pi_{ij}, z_{j,\lin})
   }
   \\
   \\
   &=
   \exp\bc{
     -\frac{(\tilde h_{jk} - m_j)^2 - (h_{jk} - m_j)^2}
           {2 S_j}
   }
   \times \\
   %%% LIKELIHOOD %%%
   &
   \prod_{\bc{(i,n,j):~\lin = k,~\tilde z_{j,\lin}=1,~z_{j,\lin}=0}}
   \p{
     \frac{ % LIKELIHOOD
       \TNpdm{y_{inj}}{\tmus_{j,\lin}}{\sigma_i}{}
     }{
       \pi_{ij} \delta_0(y_{inj}) + (1-\pi_{ij})
       \TNpdm{y_{inj}}{\mus_{j,\lin}}{\sigma_i}{}
     }
   } \times
   \\\\
   &
   \prod_{\bc{(i,n,j):~\lin = k,~\tilde z_{j,\lin}=0,~z_{j,\lin}=1}}
   \p{
     \frac{ % LIKELIHOOD
       \pi_{ij} \delta_0(y_{inj}) + (1-\pi_{ij})
       \TNpdm{y_{inj}}{\tmus_{j,\lin}}{\sigma_i}{}
     }{
       \TNpdm{y_{inj}}{\mus_{j,\lin}}{\sigma_i}{}
     }
   }
   %%% END OF LIKELIHOOD $$$
   \\\\
   \end{align*}
6. Update $e_{inj}$.


