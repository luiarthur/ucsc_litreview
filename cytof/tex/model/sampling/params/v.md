The prior distribution for $v_k$ are $v_k \mid \alpha \ind \Be(\alpha, 1)$, for 
$k = 1,...,K$. So, $p(v_k \mid \alpha) = \alpha v_k^{\alpha-1}$. 

Note that, if $\mus_{jk}>\log(2)$ then $z_{jk}=1$ by definition, which in turn
affects $v_k$. This behavior is undesirable. So, we will jointly update
$\mus_{jk}$ and $v_k$. More accurately, we will jointly update $(\bm\mus_{k:K},
\phi_k)$, where $\phi_k$ is the logit-transformation of the parameter $v_k$.

The full conditional for $(\phi_k, \mus_{j,k:K})$ is:
$$
\begin{split}
p(\phi_k, \mus_{k:K} \mid \y, \rest) 
&\propto
p(\phi_k) \times
\prod_{j=1}^J \prod_{l=k}^K 
p(\mus_{jl}\mid\psi_j, \tau^2_j, z_{jl}) \times \\
%&~~
%\prod_{i=1}^I \prod_{n=1}^{N_i} \prod_{j=1}^J 
%p(e_{inj} \mid z_{j,\lin}, \pi_{ij})^{\Ind{\lin \ge k,~z_{j,\lin}=0}} 
%\times \\
%%% MARGINALIZE OVER e_{inj} INTEAD
&~~
\prod_{i=1}^I \prod_{n=1}^{N_i} \prod_{j=1}^J 
p(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2, z_{j,\lin}, \pi_{ij})^{\Ind{\lin\ge k}}
\end{split}
$$

Since the full conditional cannot be sampled from directly, a metropolis update
is required. Let $Q_1$ be the proposal distribution. The proposal mechanism
will be as follows:

1. Given the current state $(\phi_k, \bm\mus_{k:K})$,
   sample a proposed state $\tilde\phi_k$ from $\N(\cdot \mid \phi_k, \Sigma_\phi)$ 
   for $\phi_k$, where $\Sigma_\phi$ is some positive real number to be tuned.
2. Compute the new $z_{jl}$ (from the updated $\phi_k \Rightarrow v_k$) 
   for $j = 1,...,J$ and $l=k,...,K$.
3. If $z_{jl}$ is unchanged, then the proposed state for $\mus_{jl}$ is simply
   its current state. Otherwise, the proposed state is 
   $\tmus_{jl} \sim \N(\cdot \mid \psi_j, \tau_j^2, \tilde z_{jl})$ 
4. Compute the proposal density as 
   $$
   \begin{split}
   q_1((\tilde{\phi}_k, \tilde\mus_{j,k:K}) \mid (\phi_k, \mus_{j,k:K}))
   =
   \Npdf{\tilde\phi_k}{\phi_k}{\Sigma_\phi} \times  \\
   \prod_{j=1}^J \prod_{l=k}^{K}
   p(\tilde\mus_{jl} \mid \psi_j, \tau_j^2, \tilde z_{jl})^{\Ind{\tilde z_{jl} \ne z_{jl}}}
   \end{split}
   $$
5. The proposed state $(\tilde\phi_k, \bm\tmus_{k:K})$ will be
   accepted with probability 
   $$\min(1, \Lambda)$$ where
   \begin{align*}
     \Lambda &= 
     \frac{
       p(\tilde\phi_k, \bm\tmus_{k:K} \mid \y, \rest) 
       \times
       q_1(\phi_k, \bm\mus_{k:K} \mid 
       \tilde\phi_k, \bm\tmus_{k:K}) 
     }{
       p(\phi_k, \bm\mus_{k:K} \mid \y, \rest) 
       \times
       q_1( \tilde\phi_k, \bm\tmus_{k:K} \mid 
       \phi_k, \bm\mus_{k:K} )
     }
     \\
     \\
     %%%%%%
     &=
     \frac{p(\tilde\phi_k)}{p(\phi_k)}
     \prod_{j=1}^J\prod_{l=k}^K
     \frac{
       p(\tmus_{jl} \mid \psi_j, \tau_j^2, \tilde z_{jl})
     }{
       p(\mus_{jl} \mid \psi_j, \tau_j^2, z_{jl})
     }
     \times
     \\
     &~~~
     \prod_{i=1}^I\prod_{n=1}^{N_i}\prod_{j=1}^J
     \frac{
      p(y_{inj} \mid \tmus_{j,\lin}, \sigma_i^2, \tilde z_{j,\lin}, \pi_{ij})^{
      \Ind{\lin\ge k}}
     }{
      p(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2, z_{j,\lin}, \pi_{ij})^{
      \Ind{\lin\ge k}}
     }
     \times
     \\
     &~~~
     \frac{q_1(\phi_k \mid \tilde\phi_k)}
          {q_1(\tilde\phi_k \mid \phi_k)}
     \prod_{j=1}^J\prod_{l=k}^K
     \bc{
       \frac{
         p(\mus_{jl} \mid \psi_j, \tau_j^2, z_{jl})
       }{
         p(\tmus_{jl} \mid \psi_j, \tau_j^2, \tilde z_{jl})
       }
     }^{\Ind{z_{jl} \ne \tilde z_{jl}}}
     \\
     \\
     %%%%%%
     %%%%%% CRUX!!!
     &=
     \frac{p(\tilde\phi_k)}{p(\phi_k)}
     \times
     \prod_{i=1}^I\prod_{n=1}^{N_i}\prod_{j=1}^J
     \frac{ % LIKELIHOOD
      p(y_{inj} \mid \tmus_{j,\lin}, \sigma_i^2, \tilde z_{j,\lin}, \pi_{ij})^{
      \Ind{\lin\ge k}}
     }{
      p(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2, z_{j,\lin}, \pi_{ij})^{
      \Ind{\lin\ge k}}
     }
     \\
     \\
     %%%%%%
     &=
     \frac{p(\tilde\phi_k)}{p(\phi_k)}
     \prod_{\bc{(i,n,j): \lin \ge k}}
     \frac{ % LIKELIHOOD
      p(y_{inj} \mid \tmus_{j,\lin}, \sigma_i^2, \tilde z_{j,\lin}, \pi_{ij})
     }{
      p(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2, z_{j,\lin}, \pi_{ij})
     }
     \\\\
     &=
     \exp(\phi_k - \tilde\phi_k)
     \p{\frac{1+\exp(-\phi_k)}{1+\exp(-\tilde\phi_k)}}^{\alpha+1}
     \times \\
     %%% LIKELIHOOD %%%
     &
     \prod_{\bc{(i,n,j):~\lin \ge k,~\tilde z_{j,\lin}=1,~z_{j,\lin}=0}}
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
     \prod_{\bc{(i,n,j):~\lin \ge k,~\tilde z_{j,\lin}=0,~z_{j,\lin}=1}}
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
   To obtain the new state for $v_k$, we simply need to take the 
   inverse-logit transformation of $\phi_k$.

Note that $z_{jl}$ for $l \ge k$ is a function of $v_k$. Therefore, 
$\tilde z_{jl} = 
\Ind{\Phi(h_{jk} \mid 0, \Gamma_{jj}) < \prod_{l=1}^k \tilde v_l}$ needs to be
evaluated in the expressions above. Note also that since $e_{inj}$ was
marginalized over in the computations above, it is implicitly changed when
the proposed $v_k$ is accepted. Consequently, $e_{inj}$ needs to be updated
after $v_k$ is updated. However, the update can be done any time before 
a parameter which depends on $e_{inj}$ is updated in the MCMC iteration. 
A suitable time scheme would therefore be to updated $\h_k$ immediately after
updating $v_k$, then update $e_{inj}$ immediately after. (See 5.9 for updating
$e_{inj}$.)


