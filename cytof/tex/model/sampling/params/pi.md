The prior for $\pi_{ij} \mid c_j, d$ is $\Be^\star(c_j, d)$. So, the full 
conditional is

$$
\begin{split}
p(\pi_{ij}\mid \y,\rest) \propto&~~ p(\pi_{ij}) \times
\prod_{n=1}^{N_i} 
p(e_{inj} \mid z_{j,\lin}, \pi_{ij})^{1-z_{j,\lin}}
\\
%
\propto&~~ (\pi_{ij})^{c_jd-1}(1-\pi_{ij})^{(1-c_j)d-1} \times \\
&~~\prod_{n=1}^{N_i} 
\bc{
\pi_{ij}^{e_{inj}}
(1-\pi_{ij})^{1-e_{inj}}
}^{1-z_{j,\lin}}\\
%
\propto&~~ (\pi_{ij})^{c_jd-1}(1-\pi_{ij})^{(1-c_j)d-1} \times \\
&~~
\bc{
\pi_{ij}^{\sum_{n=1}^{N_i} e_{inj}\p{1-z_{j,\lin}}}
(1-\pi_{ij})^{\sum_{n=1}^{N_i} \p{1-e_{inj}}\p{1-z_{j,\lin}}}
}\\
%
\propto&~~
(\pi_{ij})^{c_jd+\p{\sum_{n=1}^{N_i} e_{inj}\p{1-z_{j,\lin}}}-1}
(1-\pi_{ij})^{(1-c_j)d+\p{\sum_{n=1}^{N_i} \p{1-e_{inj}}\p{1-z_{j,\lin}}}-1}
\\
\end{split}
$$

Therefore, we can sample from the full conditional by sampling
from

$$
\pi_{ij} \mid \y, \rest \sim 
\Be\p{
c_jd+\p{\sum_{n=1}^{N_i} e_{inj}\p{1-z_{j,\lin}}},
(1-c_j)d+\p{\sum_{n=1}^{N_i} \p{1-e_{inj}}\p{1-z_{j,\lin}}}
}
$$


