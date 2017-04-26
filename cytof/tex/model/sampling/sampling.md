---
title: "DRAFT"
author: Arthur Lui
date: "17 April 2017"
geometry: margin=1in
fontsize: 12pt

bibliography: ../../bib/litreview.bib
bibliographystyle: plain 

# This is how you use bibtex refs: @nameOfRef
# see: http://www.mdlerch.com/tutorial-for-pandoc-citations-markdown-to-latex.html
#{{{1
header-includes: 
    - \usepackage{bm}
    - \usepackage{bbm}
    - \usepackage{graphicx}
    - \pagestyle{empty}
    - \newcommand{\norm}[1]{\left\lVert#1\right\rVert}
    - \newcommand{\p}[1]{\left(#1\right)}
    - \newcommand{\bk}[1]{\left[#1\right]}
    - \newcommand{\bc}[1]{ \left\{#1\right\} }
    - \newcommand{\abs}[1]{ \left|#1\right| }
    - \newcommand{\mat}{ \begin{pmatrix} }
    - \newcommand{\tam}{ \end{pmatrix} }
    - \newcommand{\suml}{ \sum_{i=1}^n }
    - \newcommand{\prodl}{ \prod_{i=1}^n }
    - \newcommand{\ds}{ \displaystyle }
    - \newcommand{\df}[2]{ \frac{d#1}{d#2} }
    - \newcommand{\ddf}[2]{ \frac{d^2#1}{d{#2}^2} }
    - \newcommand{\pd}[2]{ \frac{\partial#1}{\partial#2} }
    - \newcommand{\pdd}[2]{\frac{\partial^2#1}{\partial{#2}^2} }
    - \newcommand{\N}{ \mathcal{N} }
    - \newcommand{\E}{ \text{E} }
    - \def\given{~\bigg|~}
    # Figures in correct place
    - \usepackage{float}
    - \def\beginmyfig{\begin{figure}[H]\center}
    - \def\endmyfig{\end{figure}}
    - \newcommand{\iid}{\overset{iid}{\sim}}
    - \newcommand{\ind}{\overset{ind}{\sim}}
    - \newcommand{\I}{\mathrm{\mathbf{I}}}
    #
    - \allowdisplaybreaks
    - \def\M{\mathcal{M}}
#}}}1
    # FOR THIS PROJECT:
    - \newcommand{\y}{\bm{y}}
    - \newcommand{\yin}{\y_{i,n}}
    - \newcommand{\muin}{\bm{\mu}_{i,n}}
    - \newcommand{\bmu}{\bm{\mu}}
    - \newcommand{\muks}{\bmu_k^\star}
    - \newcommand{\mlins}{\mu_{\lambda_{i,n}}^*}
    - \newcommand{\lin}{{\lambda_{i,n}}}
    - \newcommand{\Z}{\mathbf{Z}}
    - \newcommand{\z}{\bm{z}}
    - \renewcommand{\v}{\bm{v}}
    - \newcommand{\bzero}{\bm{0}}
    - \newcommand{\w}{\bm{w}}
    - \newcommand{\h}{\bm{h}}
    - \newcommand{\LN}{\text{Log-}\N}
    - \newcommand{\IBP}{\text{IBP}}
    - \newcommand{\TN}{\text{TN}}
    - \newcommand{\Dir}{\text{Dirichlet}}
    - \newcommand{\IG}{\text{IG}}
    - \newcommand{\Be}{\text{Beta}}
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
    - \newcommand{\sign}[1]{\text{sign}\p{#1}}
    - \pagenumbering{gobble}
    - \newcommand{\logNpdf}[3]{\frac{1}{#1\sqrt{2\pi#3}}\exp\bc{-\frac{\p{\ln(#1)-#2}^2}{2{#3}}}}
---

# Likelihood

$$
\begin{array}{rcl}
(y_{inj} \mid \lambda_{i,n}=k, z_{jk}=1, \mu_{jk}^*,\sigma_i^2) &\sim& \LN(\mu_{jk}^*, \sigma_i^2)\\
(y_{inj} \mid \lambda_{i,n}=k, z_{jk}=0, \mu_{jk}^*,\sigma_i^2) &\sim& \pi_{ij}\delta_0(y_{inj}) + (1-\pi_{ij}) \LN(\mu_{jk}^*, \sigma_i^2) \\
\end{array}
$$

# Joint Posterior

Let $\bm\theta = \p{\bm{\mu^*, \sigma^2, v, h, \lambda, w, \tau^2, \psi, \bm\pi}}$

$$
\begin{split}
p(\bm\theta \mid K, \y, \alpha) \propto& \bc{p(\bm{w})\prod_{i=1}^I 
p(\sigma_i^2) 
\prod_{n=1}^{N_i} p(\lambda_{i,n}\mid \bm w)  \prod_{j=1}^J p(y_{inj} \mid 
\mu_{j,\lambda_{i,n}}^* , \sigma^2_i, z_{j,\lambda_{i,n}}) } \\
&\prod_{j=1}^J p(\tau_j^2) p(\psi_j) \prod_{j=1,k=1}^{J,K}  
%p_{z_{jk}}(\mu^*_{jk} \mid \psi_j, \tau_j^2) 
p(\mu^*_{jk} \mid \psi_j, \tau_j^2) 
\prod_{k=1}^Kp(v_k)p(\h_k)
\prod_{i=1,j=1}^{I,J} p(\pi_{ij})
\end{split}
$$

# Sampling via MCMC
Sampling can be done via Gibbs sampling by repeatedly updating each parameter
one at a time until convergence. Parameter updates are made by sampling from
it's full conditional distribution. Where this cannot be done conveniently, 
a metropolis step will be necessary.

# Derivation of Full Conditionals

## Full Conditional for $\bm\mu^*$

**I changed the prior here.** I thought splitting the prior for $\mu_{jk}^*$
was a little redundant as this is already done in the likelihood.
Also, I think the math got a little confusing. 

Let the prior for $\mu_{jk}^*$ be $(\mu_{jk}^* \mid \psi_j, \tau^2_j) \sim
\N(\psi_j, \tau_j^2)$. 

Let $C_1 = \bc{(i,n): (\lin=k)~\cap~(z_{jk}=1)}$.
Let $C_0 = \bc{(i,n): (\lin=k)~\cap~(z_{jk}=0)}$.

Then,

\begin{align*}
p(\mu_{jk}^* \mid \y,-) \propto&~~ p(\mu_{jk}^*\mid \psi_j, \tau_j^2) \times 
\prod_{i=1,n=1}^{I,N_i} p(y_{inj}\mid \mu_{j,\lin}^*, \sigma_i^2, z_{j,\lin})\\
%
\propto&~~ p(\mu_{jk}^*\mid \psi_j, \tau_j^2) \times 
\prod_{(i,n)\in C_1} p_1(y_{inj}\mid \mu_{jk}^*, \sigma_i^2)
\prod_{(i,n)\in C_0} p_0(y_{inj}\mid \mu_{jk}^*, \sigma_i^2)\\
%
\propto&~~\exp\bc{-\frac{(\mu_{jk}^*-\psi_j)^2}{2\tau_j^2}} \times 
\prod_{(i,n)\in C_1} \exp\bc{-\frac{(\ln(y_{inj})-\mu_{jk}^*)^2}{2\sigma_i^2}}\times\\
&~~\prod_{(i,n)\in C_0} \bc{\pi_{ij}\delta_0(y_{inj}) + (1-\pi_{ij}) 
\logNpdf{y_{inj}}{\mu_{jk}^*}{\sigma_i^2}}
\end{align*}

The full conditional is not available in closed form. But, it can be sampled
from by a metropolis step with a Normal proposal. 


## Full Conditional for $\sigma_i^2$
Let $p_1(y_{inj} \mid \mu_{j,\lin}^*, \sigma_i^2) = 
\logNpdf{y_{inj}}{\mu_{j,\lin}}{\sigma_i^2}$, the log-Normal pdf.

Let $p_0(y_{inj} \mid \mu_{j,\lin}^*, \sigma_i^2) = 
\pi_{ij} \delta_0(y_{inj}) + 
(1-\pi_{ij})p_1(y_{inj} \mid \mu_{j,\lin}, \sigma_i^2)$.

Let $p(\sigma_i^2) \propto (\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)$. 

Furthermore, let $S_1 = \bc{(j,n):z_{j,\lin}=1}$ and $S_0 = \bc{(j,n):z_{j,\lin}=0}$.  Then,

$$
\begin{split}
p(\sigma_i^2 \mid -) \propto&~~ p(\sigma_i^2) 
\prod_{j=1}^J\prod_{n=1}^{N_i} p(y_{inj} \mid \mu_{j,\lin}^*, \sigma_i^2, z_{j,\lin}) \\
%
\propto&~~ p(\sigma_i^2) 
\prod_{\bc{(j,n)\in S_1}} p_1(y_{inj}\mid\mu_{j,\lin}^* , \sigma^2_i) 
\prod_{\bc{(j,n)\in S_0}} p_0(y_{inj}\mid\mu_{j,\lin}^* , \sigma^2_i) \\
%
\propto&~~ (\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)\times \\
&~~ \prod_{\bc{(j,n)\in S_1}} \logNpdf{y_{inj}}{\mu_{j,\lin}}{\sigma_i^2} \times\\
&~~ \prod_{\bc{(j,n)\in S_0}} \pi_{ij}~\delta_0(y_{inj}) + (1-\pi_{ij})\logNpdf{y_{inj}}{\mu_{j,\lin}}{\sigma_i^2} \\
%
\end{split}
$$

As the full conditional for $\sigma_i$ is not available in closed form,
it needs to be approximated. This can be done with a metropolis step
by log-transforming $\sigma_i^2$ and using a (symmetric) Normal 
proposal distribution.

## Full Conditional for $\v$

The prior distribution for $v_l$ are $v_l \mid \alpha \ind \Be(\alpha, 1)$, for 
$l = 1,...,K$. So, $p(v_l \mid \alpha) \propto v_l^{\alpha-1}$. Also, let
$v_0 = 1$ (deterministically). Then,

\begin{align*}
p(v_k \mid \y,-) \propto&~~ p(v_k \mid \alpha) 
\prod_{(i,n):\lin \ge k} p(y_{inj} \mid \mu_{j,\lin},\sigma_i^2, z_{j,\lin})\\
\propto&~~ v_k^{\alpha-1}
\prod_{(i,n):\lin \ge k} p(y_{inj} \mid \mu_{j,\lin},\sigma_i^2, z_{j,\lin})\\
\end{align*}

For each $k = 1, \cdots, K$, the full conditional cannot be sampled from
conveniently. So, a metropolis update is required for each $v_k$.
A joint update of all the $v_k$'s may be desirable to avoid computing 
the likelihood $K$ times. This requires logit-transforming the $v_k$'s and 
using a multivariate proposal distribution centered at the current set of $\v$'s
in the metropolis update.

## Full Conditional for $\h$
Let the prior for $\h_k$ be $\h_k \sim \N_J(0, \Gamma)$.

$$
\begin{split}
p(\h_k \mid \y, -) \propto&~~ p(\h_k) 
\prod_{(i,n): \lin=k} p(y_{inj} \mid \mu_{jk}, \sigma_i^2, z_{jk}) \\
\end{split}
$$

Again, for each $k = 1, \cdots, K$, the full conditional cannot be sampled from
conveniently. So, a metropolis update is required for each $h_k$. Since $h_k$ is
multivariate Normal apriori, a multivariate Normal centered at the 
most recent $h_k$ can serve as the proposal distribution.

I think that $\h_k$ needs to be updated as a vector instead of one element 
at a time because updating each $h_{jk}$ does not take into account the correlation
between markers (in the off-diagonals of $\Gamma$).

## Full Conditional for $\bm\lambda$

The prior for $\lin$ is $p(\lin\mid \w) = w_k$.

$$
\begin{split}
p(\lin=k\mid \y,-) \propto&~~ p(\lin=k) 
\prod_{j=1}^J \prod_{(i,n):\lin=k} p(y_{inj}\mid \mu_{jk}^*, \sigma_i^2, z_{jk})\\
\end{split}
$$

Since $\lin$ has a discrete support, sampling from it's full conditional is
simply a matter of sampling each $k$ proportional to the full conditional
evaluated at $k$.

## Full Conditional for $\w$
The prior for $\w$ is $w \sim \Dir(a_1, \cdots, a_K)$

\begin{align*}
p(\w \mid -) \propto&~~ p(\w) \times \prod_{i=1}^I\prod_{n=1}^{N_i} p(\lin \mid \w)\\
\propto&~~ p(\w) \times \prod_{i=1}^I\prod_{n=1}^{N_i}\prod_{k=1}^K w_{k}^{\Ind{\lin=k}}\\
\propto&~~ \prod_{k=1}^K w_k^{a_k} \times \prod_{i=1}^I\prod_{n=1}^{N_i}\prod_{k=1}^K w_{k}^{\Ind{\lin=k}}\\
\propto&~~ \prod_{k=1}^K w_{k}^{a_k + \sum_{i=1}^I\sum_{n=1}^{N_i}\Ind{\lin=k}}\\
%
\end{align*}

Therefore,
$$
(\w \mid \bm\lambda,-) ~\sim~ \Dir\p{a_1+\sum_{i=1}^I\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=1},...,a_{K}+\sum_{i=1}^I\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=K}} 
$$

Consequently, the full conditional for $\w$ can be sampled from directly.

## Full Conditional for $\bm{\tau^2}$
Let $\tau_j^2$ have prior distribution $\tau_j^2 \sim \IG(a_\tau, b_\tau)$.
Then $\tau_j^2$ is a conjugate prior. So, it's full conditional is 

$$
\begin{split}
p(\tau_j^2 \mid \y, -) \propto&~~ p(\tau_j^2) \times 
\prod_{k=1}^K p(\mu_{jk}\mid \psi_j, \tau_j^2) \\
\propto&~~ (\tau_j^2)^{-a_\tau-1} \exp\bc{-b_\tau/\tau_j^2} \times 
(\tau_j^2)^{-K/2} \exp\bc{-\frac{\sum_{k=1}^K\p{\mu_{jk}-\psi_j}^2}{2\tau_j^2}} \\
\propto&~~ (\tau_j^2)^{-a\tau-K/2-1} 
\exp\bc{-b_\tau/\tau_j^2-\frac{\sum_{k=1}^K\p{\mu_{jk}-\psi_j}^2}{2\tau_j^2}}
\end{split}
$$

Therefore,

$$
(\tau_j^2 \mid \y, -) \sim \IG\p{a_\tau + \frac{K}{2}, b_\tau + \frac{\sum_{k=1}^K\p{\mu_{jk}-\psi_j}^2}{2}}
$$

Consequently, the full conditional for $\tau_j^2$ can be sampled from one at
a time directly.

## Full Conditional for $\bm\psi$
Let $\psi_j$ have prior distribution $\psi_j \sim \N(m_\psi, s^2_\psi)$.
Then $\psi_j$ is a conjugate prior. So, it's full conditional is 

$$
\begin{split}
p(\psi_j \mid \y, -) \propto&~~ p(\psi_j) \times 
\prod_{k=1}^K p(\mu_{jk}\mid \psi_j, \tau_j^2) \\
\propto&~~ \exp\bc{-\frac{(\psi_j-m_\psi)^2}{2s^2_\psi}} \times 
\exp\bc{-\frac{\sum_{k=1}^K\p{\mu_{jk}-\psi_j}^2}{2\tau_j^2}} \\
\end{split}
$$

Therefore,

$$
\psi_j \mid \y, - \sim \N\p{\frac{\tau_j^2 m_\psi + s^2_\psi\sum_{k=1}^K \mu_{jk}}
                                 {\tau_j^2 + Ks_\psi^2},
                            \frac{\tau_j^2 s^2_\psi}{\tau_j^2 + Ks_\psi^2}}
$$

Consequently, the full conditional for $\psi_j$ can be sampled from one at
a time directly.

## Full Conditional for $\bm\pi$
Let the prior for $\pi_{ij}$ be $\Be(c_j, d_j)$. We will set $c_j$ and $d_j$ 
according to some desired mean parameter ($\frac{c_j}{c_j+d_j}$) and 
overdispersion parameter($c_j + d_j$). Then,

$$
\begin{split}
p(\pi_{ij}\mid \y,-) \propto&~~ p(\pi_{ij}) \times 
\prod_{n:z_{j,\lin}=0} \pi_{ij}\delta_0(y_{inj}) + (1-\pi_{ij})
\logNpdf{y_{inj}}{\mu_{j,\lin}}{\sigma_i^2} \\
%
\propto&~~ (\pi_{ij})^{c_j-1}(1-\pi_{ij})^{d_j-1} \times \\
&~~\prod_{n:z_{j,\lin}=0} \pi_{ij}\delta_0(y_{inj}) + (1-\pi_{ij})
\logNpdf{y_{inj}}{\mu_{j,\lin}}{\sigma_i^2} \\
\end{split}
$$

For each $\pi_{ij}$, the full conditional cannot be sampled from conveniently.
So, a metropolis update is required for each $\pi_{ij}$.  This requires
logit-transforming the $\pi_{ij}$'s and using a Normal proposal distribution
centered at the current $\pi_{ij}$ in the metropolis update.


### Possible issues:

- Repeated columns allowed in $Z$ apriori

# Alternative Methods:

- Variational Inference for $Z$ using stick-breaking construction [@doshi2009variational]
    - takes longer and has poorer performance for lower-dimension $Z$
    - faster and has better performance for higher-dimension $Z$


[comment]: <> (%
  All these are commented
  No strange spell checks in the commetns.
  $$\alpha$$
%)

