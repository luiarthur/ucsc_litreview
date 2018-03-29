\begin{align*}
  m_{inj} \mid p_{inj}, y_{inj} &\sim \Bern(p_{inj}) \\
  \logit(p_{inj}) &:= \begin{cases}
  \beta_{0ij} - \beta_{1j}(y_{inj}-c_0)^2, & \text{if } y_{inj} < c_0\nonumber \\
  \beta_{0ij} - \beta_{1j}\p{y_{inj}-c_0}, & \text{otherwise} \nonumber \\
  \end{cases}\\
  \\
  y_{inj} \mid \mu_{inj}, \sigma^2_{inj}, \bm Z, \lin, \gamma_{inj}
  &\sim \N(\mu_{inj}, \sigma^2_{inj}) \\
  %
  %\mu_{inj} &:= \mu^*_{Z_{j\lin},\gamma_{inj}} \\
  %\sigma^2_{inj} &:= {\sigma^{2}}^*_{i,Z_{j\lin},\gamma_{inj}}\\
  \mu_{inj} &:= \mu^*_{z,l} \\
  \sigma^2_{inj} &:= {\sigma^{2}}^*_{i,z,l}\\
  z &:= Z_{j,\lin} \in\bc{0,1}, \text{~~where~}\lin \in \bc{1,...,K}\\
  l &:= \gamma_{inj} \in \bc{1,...,L^z} \\
\end{align*}

Let $\btheta$ represent all parameters (discussed in the next section).
Let $\y$ represent all $y_{inj} ~ \forall(i,n,j)$.
Let $\m$ represent all $m_{inj} ~ \forall(i,n,j)$.

The resulting **likelihood** is as follows:

\begin{align}
\mathcal{L} = p(\y, \m \mid \btheta) &= p(\m \mid \y) p(\y \mid \btheta) \nonumber\\
&= \prod_{i,n,j} p(m_{inj} \mid y_{inj}, \btheta) p(y_{inj} \mid \btheta) \nonumber\\
&= \prod_{i,n,j} \bc{
  p_{inj}^{m_{inj}} (1-p_{inj})^{1-m_{inj}} \times 
   \frac{1}{\sqrt{2\pi\sigma^2_{inj}}} \exp\bc{-\frac{(y_{inj}-\mu_{inj})^2}{2\sigma^2_{inj}}}.
}
\end{align}

The model is fully specified after priors are placed on all unknown parameters.

The marginal density for $y_{i,n,j}$ after integrating out $\lambda$
and $\gamma$ is

\begin{align}
y_{inj} \mid \theta = \sum_{k=1}^K W_{ik} \sum_{l=1}^{L^{Z_{jk}}}
\eta^{Z_{jk}}_{ijl} \cdot \N(y_{inj} \mid \mu^*_{Z_{jk}}, {\sigma^2}^*_{i,Z_{jk},l}).
\end{align}
