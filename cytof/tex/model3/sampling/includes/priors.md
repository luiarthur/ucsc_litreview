<!--
The parameters $\bm\theta \mid K$ are now explicitly written.

$$
\begin{split}
\bm\theta_1 &= \bc{
h_k, v_k,
W_{ik}, Z_{jk}
}_{i=1,j=1,k=1}^{i=I,j=J,k=K} \\
\bm\theta_2 &= \bc{
\mus_{0ij}, \mus_{1ij}, \psi_0, \psi_1, 
\tau^2_0, \tau^2_1,
\sigma^2_{ij}, \gamma_{0ij}, \gamma_{1ij}, \beta_{0ij}, \beta_{0j}, \beta_{1j},
}_{i=1,j=1,k=1}^{i=I,j=J,k=K} \\
\bm\theta_3 &= \bc{
\lin, 
\p{y_{inj}\colon m_{inj}=1},
K
}_{i=1,n=1,j=1,k=1}^{i=I,n=N_i,j=J,k=K} \\
\bm\theta &= \bc{\bm\theta_1, \bm\theta_2, \bm\theta_3}
\end{split}
$$

Note that $\bm\theta_1$ are parameters which dimensions depend on $K$.  The
parameters in $\bm\theta_2$ do not explicitly depend on $K$.  And $\bm\theta_3$
contains the remaining parameters, $K$, $\lin$ which takes on values between 1
and $K$, and the missing values for $y_{inj}$ which are sensitive to $\lin$.
-->

Let $\bm\theta$ be ... **TODO**

\begin{align*}
\beta_{0i} &\sim \N(m_{\beta_0}, s^2_{\beta_0}) ~~~
\text{(hyper-parameters determined empirically)} \\
\beta_{1i} &\sim \G(a_{\beta_1}, b_{\beta_1}) ~~~~
\text{(with mean $a_{\beta_1}/b_{\beta_1}$, determined empirically)} \\
\\
\mus_{0l} \mid \psi_0, \tau^2_0 &\sim \N_-(\psi_0, \tau^2_0), ~~~ l \in \bc{1,...,L^0} \\
\mus_{1l} \mid \psi_1, \tau^2_1 &\sim \N_+(\psi_1, \tau^2_1), ~~~ l \in \bc{1,...,L^1} \\
\sigma^2_{0il} \mid s_i &\sim \IG(a_\sigma, s_i), ~~~ l \in \bc{1,...,L^0} \\
\sigma^2_{1il} \mid s_i &\sim \IG(a_\sigma, s_i), ~~~ l \in \bc{1,...,L^1} \\
s_i &\sim \G(a_s, b_s), ~~~ i \in \bc{1,...,I} \\
\\
p(\gamma_{inj} = l) \mid \bm\eta^{Z_{inj}}_{i,j} &\propto \eta^{Z_{inj}}_{ijl},
~~~ l \in \bc{1,...,L^{Z_{inj}}}  \\
\bm\eta^0_{ij} &\sim \Dir_{L^0}(a_{\eta^0}) \\
\bm\eta^1_{ij} &\sim \Dir_{L^1}(a_{\eta^1}) \\
\\
v_k \mid \alpha &\sim \Be(\alpha/K, 1) \\
\alpha &\sim \G(a_\alpha, b_\alpha) \\
\h_k &\sim \N_J(\bm{0}, \bm G) \\
Z_{jk} \mid h_{jk}, v_k &:=
\Ind{\Phi(h_{jk} \mid 0, \Gamma_{jj}) < v_k} \\
\\
p(\lin=k \mid \bm W_i) &= W_{ik} \\
\bm W_{i} &\sim \Dir_K(d) \\
\end{align*}

Note that $X ~ \N_-(m,s^2)$ denotes that $X$ is distributed Normally with
mean $m$ and variance $s^2$, truncated to take on only *negative* values.
Similarly, $X ~ \N_+(m,s^2)$ denotes that $X$ is distributed Normally with
mean $m$ and variance $s^2$, truncated to take on only *positive* values.
The Gamma distribution with parameters $(a,b)$ has mean $a/b$.
The inverse-Gamma distribution with parameters $(a,b)$ has mean $b / (a-1)$.
