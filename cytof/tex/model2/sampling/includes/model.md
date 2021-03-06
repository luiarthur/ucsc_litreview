\begin{align*}
  m_{inj} \mid p_{inj}, y_{inj} &\sim \Bern(p_{inj}) \\
  %\logit(p_{inj}) &:= \beta_{0ij} - \beta_{1j}~y_{inj} \\
  \logit(p_{inj}) &:= \begin{cases}
  \beta_{0ij} - \beta_{1j}(y_{inj}-c_0)^2, & \text{if } y_{inj} < c_0\nonumber \\
  \beta_{0ij} - \beta_{1j}x_j\sqrt{y_{inj}-c_0}, & \text{otherwise} \nonumber \\
  \end{cases}\\
  \\
  y_{inj} \mid \mu_{inj}, \gamma_{inj}, \sigma^2_{ij}, \bm Z, \lin
  &\sim \N(\mu_{inj}, (\gamma_{inj}+1) \sigma^2_{ij}) \\
  \mu_{inj} &:= \mu^*_{Z_{j\lin}ij} \\
  \gamma_{inj} &:= \gamma_{Z_{j\lin}ij}^* \\
\end{align*}

Let $\btheta$ represent all parameters (discussed in the next section).
Let $\y$ represent all $y_{inj} ~ \forall(i,n,j)$.
Let $\m$ represent all $m_{inj} ~ \forall(i,n,j)$.

The resulting **likelihood** is as follows:

\begin{align*}
\mathcal{L} = p(\y, \m \mid \btheta) &= p(\m \mid \y) p(\y \mid \btheta) \\
&= \prod_{i,n,j} p(m_{inj} \mid y_{inj}, \btheta) p(y_{inj} \mid \btheta) \\
&= \prod_{i,n,j} \bc{
  p_{inj}^{m_{inj}} (1-p_{inj})^{1-m_{inj}} \times 
   \frac{1}{\sqrt{2\pi(\gamma_{inj}+1)\sigma^2_{ij}}} \exp\bc{-\frac{(y_{inj}-\mu_{inj})^2}{2(\gamma_{inj}+1)\sigma^2_{ij}}}
}
\end{align*}

The model is fully specified after priors are placed on all unknown parameters.
