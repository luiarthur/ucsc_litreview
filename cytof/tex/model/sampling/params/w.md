The prior for $\w_i$ is $w_i \sim \Dir(a_1, \cdots, a_K)$. So the full
conditional for $\w_i$ is:

\begin{align*}
p(\w_i \mid \rest) \propto&~~ p(\w_i) \times \prod_{n=1}^{N_i} p(\lin \mid \w_i)\\
\propto&~~ p(\w_i) \times \prod_{n=1}^{N_i}\prod_{k=1}^K w_{k}^{\Ind{\lin=k}}\\
\propto&~~ \prod_{k=1}^K w_k^{a_k} \times \prod_{n=1}^{N_i}\prod_{k=1}^K w_{ik}^{\Ind{\lin=k}}\\
\propto&~~ \prod_{k=1}^K w_{ik}^{a_k + \sum_{n=1}^{N_i}\Ind{\lin=k}}\\
%
\end{align*}

Therefore,
$$
(\w_i \mid \bm\lambda_i,K,\y,\rest) ~\sim~ \Dir\p{a_1+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=1},...,a_{K}+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=K}} 
$$

Consequently, the full conditional for $\w_i$ can be sampled from directly from a Dirichlet distribution of the form above.


