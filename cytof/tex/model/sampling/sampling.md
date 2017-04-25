---
title: "DRAFT (after dropping $i$)"
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
(y_{inj} \mid \lambda_{i,n}=k, z_{ij}=1, \mu_{jk}^*,\sigma_i^2) &\sim& \LN(\mu_{jk}^*, \sigma_i^2)\\
(y_{inj} \mid \lambda_{i,n}=k, z_{ij}=0, \mu_{jk}^*,\sigma_i^2) &\sim& \pi_{ij}\delta_0(y_{inj}) + (1-\pi_{ij}) \LN(\mu_{jk}^*, \sigma_i^2) \\
\end{array}
$$

# Joint Posterior

Let $\bm\theta = \p{\bm{\sigma^2, v, h, \lambda, w, \tau^2, \psi, \mu^*}}$

$$
\begin{split}
p(\bm\theta \mid K, \y, \alpha, \bm\pi) \propto& \bc{p(\bm{w})\prod_{i=1}^n 
p(\sigma_i^2) 
\prod_{n=1}^{N_i} p(\lambda_{i,n}\mid \bm w)  \prod_{j=1}^J p(y_{inj} \mid 
\mu_{j,\lambda_{i,n}}^* , \sigma^2_i, z_{j,\lambda_{i,n}}) } \\
&\prod_{j=1}^J p(\tau_j^2) p(\psi_j) \prod_{j=1,k=1}^{J,K}  p_{z_{jk}}(\mu^*_{jk} \mid \psi_j, \tau_j^2) 
\prod_{k=1}^Kp(v_k)p(\h_k)
\end{split}
$$

# Sampling via MCMC
Sampling can be done via Gibbs sampling by repeatedly updating each parameter
one at a time until convergence. Parameter updates are made by sampling from
it's full conditional distribution. Where this cannot be done conveniently, 
a metropolis step will be necessary.

# Derivation of Full Conditionals

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
\propto&~~ p(\sigma_i^2) \prod_{\bc{(j,n)\in S_1} }
p_1(y_{inj}\mid\mu_{j,\lin}^* , \sigma^2_i) \times\\
&~~~~~~~~~\prod_{\bc{(j,n)\in S_0}} 
p_0(y_{inj}\mid\mu_{j,\lin}^* , \sigma^2_i) \\
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

## Full Conditional for $\h$

## Full Conditional for $\bm\lambda$

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

Consequently, the full conditional for $\w$ can be sampled from in a Gibbs sampler
from a Dirichlet distribution.

## Full Conditional for $\bm{\tau^2}$

## Full Conditional for $\bm\psi$

## Full Conditional for $\bm\mu^*$


# Recap

\begin{align*}
%\sigma_i^2:
%\sigma_i^2 \mid \y,\bmu,- &\sim  \IG\p{a_\sigma + \frac{N_iJ}{2}, b_\sigma + \frac{\sum_{j=1}^J\sum_{n=1}^{N_i} \p{y_{i,n,j}-\mu^\star_{j,\lambda_{i,n}}}^2}{2}} \\
%
%\mu_{j,k}^\star \mid z_{j,k}=1, y_{i,n,j}, \tau^2_j,-&\sim \N^+\p{\frac{\tau_j^2\sum_{\bc{(i,n):\lambda_{i,n}=k}} y_{i,n,j}}{c_{jk}\tau_j^2+\sigma_i^2},\frac{\tau_j^2\sigma_i^2}{c_{jk}\tau_j^2+\sigma_i^2}} \\
%\mu_{j,k}^\star \mid z_{j,k}=0, y_{i,n,j}, \tau^2_j,-&\sim \N^-\p{\frac{\tau_j^2\sum_{\bc{(i,n):\lambda_{i,n}=k}} y_{i,n,j}}{c_{jk}\tau_j^2+\sigma_i^2},\frac{\tau_j^2\sigma_i^2}{c_{jk}\tau_j^2+\sigma_i^2}} \\
%p(\tau^2_{ij} \mid \bmu^\star-) &\propto \tau_{ij}^{2(a_\tau-1)} \exp\bc{-b_{\tau}/\tau_{ij}^2} \prod_{k=1}^K q_{jk}(\mu_{jk}^\star)\\
%\\
%h_{j,k}\mid z_{jk}=1,v_l- &\sim \TN\p{0,\Gamma_{jj},-\infty, \Phi^{-1}\p{\prod_{l=1}^k v_l\mid 0, \Gamma_{jj}}} \\
%p(v_l\mid z_{jk}=0,v_{-l},-) &\propto v_l^{a_v-1} \times \Ind{v_l < \frac{\Phi(h_{jk}|0,\Gamma_{jj})}{\prod_{d\ne l}^k v_d}} \text{\quad Truncated Beta?}\\
\h_k\mid - &\propto p(\h_k) \prod_{j=1}^J p_{z_{jk}}(\mu^*_{jk} \mid \psi_j, \tau_j^2) \\
%
v_l\mid z_{jk}- &\propto p(v_l) \prod_{j=1}^Jp_{z_{jk}}(\mu^*_{jk} \mid \psi_j, \tau_j^2) \\
%
z_{jk}(h_{jk},\v) &:= \Ind{\Phi(h_{jk} | 0, \Gamma_{jj}) < \prod_{l=1}^k v_l} \\
\\
%
p(\lambda_{i,n}=k \mid w_{i,k}, -) &\propto w_{i,k} \exp\bc{-\frac{1}{2\sigma_i^2}\sum_{j=1}^J\p{y_{i,n,j}-\mu^*_{j,k}}^2} \\
%
\w \mid \bm\lambda,- &\sim \Dir\p{a_1+\sum_{i=1}^I\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=1},...,a_{K}+\sum_{i=1}^I\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=K}} \\
%
\\
p(\tau_j^2|-) &\propto p(\tau_j^2) \times \prod_{k=1}^K p_{z_{jk}}(\mu_{jk}^* \mid \psi_j, \tau_j^2)\\
%
p(\psi_j\mid -) &\propto p(\psi_j) \times \prod_{k=1}^K p_{z_{jk}}(\mu_{jk}^* \mid \psi_j, \tau_j^2)\\
%
p(\mu^*_{jk} \mid z_{jk}=1, -) &\propto p_1(\mu^*_{jk} \mid \psi_j, \tau_j^2) \times \prod_{(i,n):\lambda_{in}=k} p(y_{inj} \mid \mu_{jk}^*, \sigma_i^2) \times \Ind{\mu_{jk}^*>0}\\
p(\mu^*_{jk} \mid z_{jk}=0, -) &\propto p_0(\mu^*_{jk} \mid \psi_j, \tau_j^2) \times \prod_{(i,n):\lambda_{in}=k} p(y_{inj} \mid \mu_{jk}^*, \sigma_i^2) \times \Ind{\mu_{jk}^*<0}\\
\end{align*}

where 

- $p_0(\mu^*_{jk} \mid \psi_j, \tau_j^2) = \ds\frac{\frac{1}{\sqrt{2\pi\tau_j^2}}\exp\bc{-\frac{(\mu_{jk}^* - \psi_j)^2}{2\tau_j^2}}}{1-\Phi\p{\frac{\mu_{jk}-\psi_j}{\tau_j}}}$

- $p_1(\mu^*_{jk} \mid \psi_j, \tau_j^2) = \ds\frac{\frac{1}{\sqrt{2\pi\tau_j^2}}\exp\bc{-\frac{(\mu_{jk}^* - \psi_j)^2}{2\tau_j^2}}}{\Phi\p{\frac{\mu_{jk}-\psi_j}{\tau_j}}}$

- $p(\h_k) \propto \exp\bc{-\frac{\h_k'(\Gamma^{-1})\h_k}{2}}$

- $p(v_l) \propto v_l^{\alpha-1}$

- $p(\tau_j^2) \propto (\tau_j^2)^{-a_\tau-1} \exp\bc{-b_\tau / \tau_j^2}$

- $p(\psi_j^2) \propto \exp\bc{-\frac{(\psi_j - m_\psi)^2}{2 s_\psi^2}}$

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

