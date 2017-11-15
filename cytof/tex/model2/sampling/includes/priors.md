The parameters $\bm\theta \mid K$ are now explicitly written.

$$
\begin{split}
\bm\theta = \bc{
h_k, v_k, \mus_{j0}, \mus_{j1}, \psi_0, \psi_1, 
\tau^2_0, \tau^2_1, W_{ik}, \lin, 
\sigma^2_{ij}, \gamma_{ij0}, \gamma_{ij1}, \beta_{ij0}, \beta_{j0}, \beta_{j1},
y_{inj}\colon m_{inj}=1
}_{i=1,n=1,j=1,k=1}^{i=I,n=N_i,j=J,k=K}
\end{split}
$$

\begin{align*}
\log(\beta_{j1}) &\sim \N(0, s^2_{\beta_1}) \\
\beta_{ij0} \mid \bar\beta_{j0} &\sim \N(\bar\beta_{j0}, s^2_{\beta_0}) \\
\bar\beta_{j0} &\sim \N(0, s^2_{\beta}) \\
%
\gamma_{ij1} &:= 0 \\
\gamma_{ij0} &\sim \IG(a_\gamma.b_\gamma) \\
\sigma^2_{ij} &\sim \IG(a_\sigma, b_\sigma) \\
\\
\mus_{j0} \mid \psi_0, \tau^2_0 &\sim \N_-(\psi_0, \tau^2_0) \\
\mus_{j1} \mid \psi_1, \tau^2_1 &\sim \N_+(\psi_1, \tau^2_1) \\
\psi_{0} &\sim \N_-(\bar\psi_0, s^2_{\psi_0}) \\
\psi_{1} &\sim \N_+(\bar\psi_1, s^2_{\psi_1}) \\
\tau^2_{0} &\sim \IG(a_{\tau_0}, b_{\tau_0}) \\
\tau^2_{1} &\sim \IG(a_{\tau_1}, b_{\tau_1}) \\
\\
v_k &\sim \Be(\alpha, 1) \\
b_k &:= \prod_{l=1}^k v_k \\
h_k &\sim \N(\bm{0}, \bm G) \\
\\
p(\lin=k \mid \bm W_i) &= W_{ik} \\
\bm W_{i} &\sim \Dir(d, ..., d) \\
\end{align*}

