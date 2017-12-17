Standard MCMC techniques like Gibbs sampling and the Metropolis method are used
to sample from the posterior distribution of the parameters.
In each of the simulations, 200 samples were gathered after a burn-in of 1200 
iterations. The MCMC was thinned by a factor of 5. (i.e. only one of every
5 samples are kept.)

## Priors

The specific prior distributions (including hyper-parameters) are included here.

\begin{align*}
\beta_{1j} &\sim \G(90, 30) ~~~~ \text{(mean=3, var=0.1)} \\
\beta_{0ij} \mid \bar\beta_{0j} &\sim \N(\bar\beta_{0j}, \text{var}=0.1) \\
\bar\beta_{0j} &\sim \N(-11, \text{var}=0.1) \\
\\
\gamma_{1ij}^* &:= 0 \\
\gamma_{0ij}^* &\sim \IG(6, 10) ~~~~ \text{(mean=2, var=1)} \\
\sigma^2_{ij} &\sim \IG(2, 1) ~~~~ \text{(mean=1, var=$\infty$)} \\
\mus_{0ij} \mid \psi_0, \tau^2_0 &\sim \N_-(\psi_0, \tau^2_0) \\
\mus_{1ij} \mid \psi_1, \tau^2_1 &\sim \N_+(\psi_1, \tau^2_1) \\
\psi_{0} &\sim \N_-(-3, 4) \\
\psi_{1} &\sim \N_+(3, 4) \\
\tau^2_{0} &\sim \IG(2, 1) \\
\tau^2_{1} &\sim \IG(2, 1) \\
\\
v_k &\sim \Be(\alpha=1, 1) \\
%b_k &:= \prod_{l=1}^k v_k \\
\h_k &\sim \N(\bm{0}, \bm G=\I_J) \\
Z_{jk} \mid h_{jk}, v_{1,...,k} &:=
\Ind{\Phi(h_{jk} \mid 0, G_{jj}) < \prod_{l=1}^k v_l} \\
\\
p(\lin=k \mid \bm W_i) &= W_{ik} \\
\bm W_{i} &\sim \Dir(1/K, ..., 1/K) \\
\end{align*}


