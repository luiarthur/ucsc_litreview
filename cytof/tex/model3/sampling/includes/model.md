<!--
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
-->

We introduce latent indicators for latent cell types, $\lambda_{in}$, $i=1,
\ldots, I$ and $n=1, \ldots, N_i$.  $\lambda_{in} \in \{1, \ldots, K\}$ denotes
the cell phenotype of cell $n$ in sample $i$ defined by column $k$ of $J \times
K$ binary matrix $\Z$.  Element $z_{j, k} \in \{0, 1\}$ indicates if marker $j$
is expressed in cell phenotype $k$.  Event $z_{j,k}=0$ represents that marker
$j$ is not expressed, and $z_{j,k}=1$ for expression. Given $z_{j,
\lambda_{i,n}}$, we assume a mixture of normals for $y_{inj}$, 

\begin{align*}
y_{inj} \mid \mu^*, \sigma^{2 *}_{i} \ind
\begin{cases}
\sum_{\ell=1}^{L^0} \eta^0_{ij\ell} \N(\mu^\star_{0\ell}, \sigma^{2 \star}_{0i\ell}), &\mbox{if $z_{j,k}=0$},\\
\sum_{\ell=1}^{L^1} \eta^1_{ij\ell} \N(\mu^\star_{1\ell}, \sigma^{2 \star}_{1i\ell}), &\mbox{if $z_{j,k}=1$},\\
\end{cases}
\end{align*}
where $L^0$ and $L^1$ are fixed, $0 < \eta^0_{ij\ell} < 1$ with $\sum_{\ell} \eta^0_{ij\ell}=1$ and $0 < \eta^1_{ij\ell} < 1$ with $\sum_{\ell} \eta^1_{ij\ell}=1$.  Given $\lambda_{in}=k$ we define $\gamma_{inj}$; for $i=1, \ldots, I$, $n=1, \ldots, N_i$ and $j=1, \ldots, J$,
\begin{eqnarray*}
p(\gamma_{inj} = \ell)=\eta^{z_{jk}}_{in\ell}, \mbox{ where }~ \ell \in \{1,\ldots, L^{z_{jk}}\}.
\end{eqnarray*}
Given $\lambda_{in}=k$ and $\gamma_{inj}=\ell$, we assume a normal distribution for $y_{inj}$; for $i=1, \ldots, I$, $n=1, \ldots, N_i$ and $j=1, \ldots, J$,
\begin{align*}
  y_{inj} \mid \mu_{inj}, \sigma^2_{inj}  &\ind \N(\mu_{inj}, \sigma^2_{inj}),
\end{align*}
where $\mu_{inj} = \mu^\star_{z_{j,k},\ell}$ and $\sigma^2_{inj} = {\sigma^{2}}^\star_{iz_{j,k}\ell}$.  Given $y_{inj}$, we assume a Bernoulli distribution for $m_{inj}$; for $i=1, \ldots, I$, $n=1, \ldots, N_i$ and $j=1, \ldots, J$,
\begin{align*}
  m_{inj} \mid p_{inj} &\ind \Bern(p_{inj}) \\
  \logit(p_{inj}) &:= \begin{cases}
  \beta_{0i} - \beta_{1i}(y_{inj}-c_0)^2, & \text{if } y_{inj} < c_0\nonumber, \\
  \beta_{0i} - \beta_{1i}c_1\p{y_{inj}-c_0}, & \text{otherwise}, \nonumber \\
  \end{cases}
\end{align*}
where $c_0$ and $c_1$ are fixed.

Let $\btheta$ represent all parameters (discussed in the next
section). Let $\y$ represent all $y_{inj} ~ \forall(i,n,j)$. Let
$\m$ represent all $m_{inj} ~ \forall(i,n,j)$.

The resulting \textbf{likelihood} is as follows:

\begin{align}
\mathcal{L} = p(\y, \m \mid \btheta) &= p(\m \mid \y) p(\y \mid \btheta) \nonumber\\
&= \prod_{i,n,j} p(m_{inj} \mid y_{inj}, \btheta) p(y_{inj} \mid \btheta) \nonumber\\
&= \prod_{i,n,j} \bc{
  p_{inj}^{m_{inj}} (1-p_{inj})^{1-m_{inj}} \times 
   \frac{1}{\sqrt{2\pi\sigma^2_{inj}}} \exp\bc{-\frac{(y_{inj}-\mu_{inj})^2}{2\sigma^2_{inj}}}
}.
\end{align}

The model is fully specified after priors are placed on all unknown
parameters. The marginal density for $y_{i,n,j}$ after integrating out $\lambda$
and $\gamma$ is
\begin{align}
p(y_{inj} \mid \theta) = \sum_{k=1}^K W_{ik} \sum_{\ell=1}^{L^{Z_{jk}}}
\eta^{Z_{jk}}_{ijl} \cdot \N(y_{inj} \mid \mu^*_{Z_{jk}, \ell}, {\sigma^2}^*_{i,Z_{jk},\ell}).
\end{align}


