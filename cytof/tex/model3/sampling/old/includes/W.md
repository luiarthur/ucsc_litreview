The prior for $\bm{W}_i$ is $\bm W_i \sim \Dir(d, \cdots, d)$. So the full
conditional for $\bm{W}_i$ is:

\begin{align*}
p(\bm W_i \mid \rest) \propto&~~ p(\bm{W}_i) \times \prod_{n=1}^{N_i} p(\lin \mid \bm{W}_i)\\
\propto&~~ p(\bm{W}_i) \times \prod_{n=1}^{N_i}\prod_{k=1}^K W_{ik}^{\Ind{\lin=k}}\\
\propto&~~ \prod_{k=1}^K W_{ik}^{d-1} \times \prod_{n=1}^{N_i}\prod_{k=1}^K W_{ik}^{\Ind{\lin=k}}\\
\propto&~~ \prod_{k=1}^K W_{ik}^{\p{d + \sum_{n=1}^{N_i}\Ind{\lin=k}}-1}\\
%
\end{align*}

Therefore,
$$
\bm{W}_i \mid \y,\rest ~\sim~ \Dir\p{d+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=1},...,d+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=K}} 
$$

Consequently, the full conditional for $\bm{W}_i$ can be sampled from directly from a Dirichlet distribution of the form above.


