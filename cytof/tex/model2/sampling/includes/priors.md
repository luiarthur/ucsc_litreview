The parameters $\bm\theta \mid K$ are now explicitly written.

$$
\begin{split}
\bm\theta = \bc{
h_k, v_k, \mus_{ij0}, \mus_{ij1}, \psi_0, \psi_1, 
\tau^2_0, \tau^2_1, W_{ik}, \lin, 
\sigma^2_{ij}, \gamma_{ij0}, \gamma_{ij1}, \beta_{0ij}, \beta_{0j}, \beta_{1j},
y_{inj}\colon m_{inj}=1
}_{i=1,n=1,j=1,k=1}^{i=I,n=N_i,j=J,k=K}
\end{split}
$$

\begin{align*}
\beta_{1j} &\sim \G(a_\beta, b_\beta) ~~~~ \text{(with mean $a_\beta/b_\beta$)} \\
\beta_{0ij} \mid \bar\beta_{0j} &\sim \N(\bar\beta_{0j}, s^2_{\beta_0}) \\
\bar\beta_{0j} &\sim \N(0, s^2_{\beta}) \\
\\
\gamma_{ij1}^* &:= 0 \\
\gamma_{ij0}^* &\sim \IG(a_\gamma.b_\gamma) \\
\sigma^2_{ij} &\sim \IG(a_\sigma, b_\sigma) \\
\mus_{ij0} \mid \psi_0, \tau^2_0 &\sim \N_-(\psi_0, \tau^2_0) \\
\mus_{ij1} \mid \psi_1, \tau^2_1 &\sim \N_+(\psi_1, \tau^2_1) \\
\psi_{0} &\sim \N_-(\bar\psi_0, s^2_{\psi_0}) \\
\psi_{1} &\sim \N_+(\bar\psi_1, s^2_{\psi_1}) \\
\tau^2_{0} &\sim \IG(a_{\tau_0}, b_{\tau_0}) \\
\tau^2_{1} &\sim \IG(a_{\tau_1}, b_{\tau_1}) \\
\\
v_k &\sim \Be(\alpha, 1) \\
%b_k &:= \prod_{l=1}^k v_k \\
\h_k &\sim \N(\bm{0}, \bm G) \\
Z_{jk} \mid h_{jk}, v_{1,...,k} &:=
\Ind{\Phi(h_{jk} \mid 0, \Gamma_{jj}) < \prod_{l=1}^k v_l} \\
\\
p(\lin=k \mid \bm W_i) &= W_{ik} \\
\bm W_{i} &\sim \Dir(d, ..., d) \\
\end{align*}

Note that $X ~ \N_-(m,s^2)$ denotes that $X$ is distributed Normally with
mean $m$ and variance $s^2$, truncated to take on only *negative* values.
Similarly, $X ~ \N_+(m,s^2)$ denotes that $X$ is distributed Normally with
mean $m$ and variance $s^2$, truncated to take on only *positive* values.

