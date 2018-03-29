\begin{align*}
p(s_i \mid \y, \rest) &\propto p(s_i) \times \prod_{z=0}^1 p(\sss_{zil} \mid s_i)\\
&\propto s_i^{a_s-1} \exp\bc{-b_s s_i} \times \prod_{z=0}^1 s_i^{a_\sigma} \exp\bc{-s_i / \sss_{zil}} \\
&\propto s_i^{a_s + 2 a_\sigma - 1} \exp\bc{-s_i \p{b_s + \sum_{z=0}^1 1 / \sss_{zil}}} \\
\end{align*}

$$
\therefore, s_i \mid \y, \rest \sim 
\G\p{a_s + 2 a_\sigma, \frac{\sss_{0il} + \sss_{1il}}{\sss_{0il} \cdot \sss_{1il}}}
$$
