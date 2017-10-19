For notational convenience, note that $\kappa_j = \logit(c_j)$ and
$\rho = \log(d)$. This implies that $c_j = \frac{1}{1+\exp(-\kappa_j)}$
and $d=\exp(\rho)$.

The prior for $\kappa_j = \logit(c_j)$ is $\kappa_j \ind \N(0, s^2_c)$. 
The full conditional for $\kappa_j$ is then:

\begin{align*}
p(\kappa_j \mid \rest) 
\propto&~~ 
p(\kappa_j)\times
\prod_{i=1}^{I} p(\pi_{ij} \mid c_j, d)\\
%
\propto&~~ 
\exp\p{-\frac{\kappa_j^2}{2s_c^2}}
\times \\
&~~ 
\prod_{i=1}^{I}
\piconst (\pi_{ij})^{\piconsta-1} (1-\pi_{ij})^{\piconstb-1} \\
\\
%
\propto&~~ 
\exp\p{-\frac{\kappa_j^2}{2s_c^2}}
\prod_{i=1}^{I}
\frac{(\pi_{ij})^{\piconsta}(1-\pi_{ij})^{\piconstb}}{\Gamma(\piconsta)\Gamma(\piconstb)}
%
\end{align*}

The parameter $c_j$ can be updated by updating $\kappa_j$ and
then taking the inverse-logit the result. That is, we sample a candidate value
for the parameter $\tilde{\kappa_j}$ from a Normal proposal centered at the
current iterate (say $\kappa_j$) of the MCMC. The proposed state is accepted
with probability

$$
\min\bc{1, \frac{p(\tilde{\kappa_j}\mid \y,\rest)}
                {p(\kappa_j\mid \y,\rest)}}.
$$

The new state in the MCMC for $c_j$ is then $\frac{1}{1+\exp(-\kappa_j)}$.



