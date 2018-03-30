\begin{align*}
p(s_i \mid \y, \rest) &\propto p(s_i) \times \prod_{z=0}^1 \prod_{\ell=1}^{L^z} p(\sss_{zi\ell} \mid s_i)\\
&\propto s_i^{a_s-1} \exp\bc{-b_s s_i} \times \prod_{z=0}^1  \prod_{\ell=1}^{L^z} s_i^{a_\sigma} \exp\bc{-s_i / \sss_{zi\ell}} \\
&\propto s_i^{a_s + (L^0 + L^1)a_\sigma - 1} \exp\bc{-s_i \p{b_s + \sum_{z=0}^1 \sum_{\ell=1}^{L^z} 1 / \sss_{zi\ell}}}.
\end{align*}

$$
\therefore s_i \mid \y, \rest \sim 
\G\p{a_s + (L^0 + L^1)a_\sigma, ~~ b_s + \sum_{z=0}^1 \sum_{\ell=1}^{L^z} \frac{1}{\sss_{zi\ell}} }.
$$

