The prior for $\bm\eta^z_{ij}$ is $\bm \eta^z_{ij} \sim \Dir_{L^z}(a_{\eta^z})$, for
$z\in\bc{0,1}$. So the full conditional for $\bm\eta^z_{ij}$ is:

\begin{align*}
p(\bm \eta^z_{ij} \mid \rest) \propto&~~ p(\bm{\eta}^z_{ij}) \times \prod_{n=1}^{N_i} p(\gamma_{inj} \mid \bm \eta^z_{ij})\\
\propto&~~ p(\bm \eta^z_{ij}) \times \prod_{n=1}^{N_i}\prod_{\ell=1}^{L^z} \p{\eta^z_{ij\ell}}^{\Ind{ \gamma_{inj}=\ell ~\cap~ Z_{j\lin=z}}}\\
%
\propto&~~ \prod_{\ell=1}^{L^z} \p{\eta^z_{ij\ell}}^{a_{\eta^z}-1} \times 
\prod_{n=1}^{N_i}\prod_{\ell=1}^{L^z} \p{\eta^z_{ij\ell}}^{\Ind{ \gamma_{inj}=\ell ~\cap~ Z_{j\lin=z}}}\\
\propto&~~ \prod_{\ell=1}^{L^z} \p{\eta^z_{ij\ell}}^{\p{a_{\eta^z} + \sum_{n=1}^{N_i} \Ind{ \gamma_{inj}=\ell ~\cap~ Z_{j\lin=z}}} - 1}\\
%
\end{align*}

Therefore,
$$
\bm{\eta}^z_{ij} \mid \y,\rest ~\sim~ \Dir_{L^z}\p{a^*_1,...,a^*_{L^z}}
$$
where $a^*_\ell = a_{\eta^z}+\sum_{n=1}^{N_i}\Ind{\gamma_{inj}=\ell ~\cap~
Z_{j\lin}=z}$. Consequently, the full conditional for $\bm{\eta}^z_{ij}$ can be
sampled from directly from a Dirichlet distribution of the form above.


