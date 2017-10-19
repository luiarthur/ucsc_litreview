The prior for $\rho = \log(d)$ is $\rho \sim \N(m_d, s^2_d)$.
The full conditional for $\rho$ is then:

\begin{align*}
p(\rho \mid \rest) 
\propto&~~ 
p(\rho)\times
\prod_{i=1}^{I} \prod_{j=1}^J p(\pi_{ij} \mid c_j, d)\\
%
\propto&~~ 
\exp\p{-\frac{(\rho-m_d)^2}{2s_d^2}}
\times \\
&~~ 
\prod_{i=1}^{I} \prod_{j=1}^J 
\piconst (\pi_{ij})^{\piconsta-1} (1-\pi_{ij})^{\piconstb-1} \\
\\
%
\propto&~~ 
\exp\p{-\frac{(\rho-m_d)^2}{2s_d^2}}
\Gamma(\exp(\rho))
\prod_{i=1}^{I} \prod_{j=1}^J 
\frac{(\pi_{ij})^{\piconsta}(1-\pi_{ij})^{\piconstb}}{\Gamma(\piconsta)\Gamma(\piconstb)}
%
\end{align*}

The parameter $d$ can be updated by updating $\rho$ and
then taking the inverse-logit the result. That is, we sample a candidate value
for the parameter $\tilde{\rho}$ from a Normal proposal centered at the
current iterate (say $\rho$) of the MCMC. The proposed state is accepted
with probability

$$
\min\bc{1, \frac{p(\tilde{\rho}\mid \y,\rest)}
                {p(\rho\mid \y,\rest)}}.
$$

The new state in the MCMC for $d$ is then $\exp(\rho)$.


