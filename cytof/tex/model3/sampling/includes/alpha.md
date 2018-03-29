\begin{align*}
p(\alpha \mid \y, \rest) &\propto p(\alpha) \times \prod_{k=1}^K p(v_k \mid \alpha) \\
&\propto \alpha^{a_\alpha - 1} \exp\bc{-b_\alpha \alpha} \times \prod_{k=1}^K 
\alpha~v_k^{\alpha/K} \\
&\propto \alpha^{a_\alpha + K -1} \exp\bc{-\alpha\p{b_\alpha + 
\frac{\sum_{k=1}^K \log v_k}{K}}}
\end{align*}

$$
\therefore \alpha \mid \y, \rest \sim 
\G\p{a_\alpha + K,~ b_\alpha + \frac{\sum_{k=1}^K \log v_k}{K}}
$$
