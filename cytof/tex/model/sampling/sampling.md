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
    - \newcommand{\mus}{\mu^\star}
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
    - \newcommand{\rest}{\text{rest}}
    - \newcommand{\logit}{\text{logit}}
---

# Likelihood

$$
\begin{cases}
y_{inj} \mid \lambda_{i,n}=k, z_{jk}=1, \mus_{jk},\sigma_i^2 &\sim~ \LN(\mus_{jk}, \sigma_i^2)\\
y_{inj} \mid \lambda_{i,n}=k, z_{jk}=0, \mus_{jk},\sigma_i^2 &\sim~ \pi_{ij}\delta_0(y_{inj}) + (1-\pi_{ij}) \LN(\mus_{jk}, \sigma_i^2) \\
\end{cases}
$$

# Priors

- $\mus_{jk}$:
$$\begin{cases}
\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk}=1 ~~&\sim~~ 
\N(\psi_j, \tau_j^2)\Ind{\mus_{jk} > 0} \\
%
\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk}=0 ~~&\sim~~ 
\N(\psi_j, \tau_j^2)\Ind{\mus_{jk} < 0} \\
\end{cases}
$$
- $\psi_j$: 
    $$\psi_j \sim \N(m_\psi, s^2_\psi)$$
- $\tau^2_j$: 
    $$\tau^2_j \sim \IG(a_\tau, b_\tau)$$
- $\pi_{ij}$: 
    $$
    \begin{split}
    \pi_{ij} \mid c_j, d &\sim \Be^\star(c_j, d) \\
    \logit(c_j) &\sim \N(0,s^2_c) \\
    \log(d) &\sim \N(m_d,s^2_d) \\
    \end{split}
    $$
    - where $\Be^*(c,d)$ is a Beta distribution parameterized with a mean 
      parameter $c$ and a dispersion parameter $d$ such that 
      $\Be^*(c,d) = \Be(cd, (1-c)d)$, for some $c\in(0,1)$ and $d > 0$.
- $\sigma^2_i$:
    $$ \sigma^2_i \sim \IG(a_\sigma, b_\sigma)$$
- $v_l$:
    $$v_l \mid \alpha \sim \Be(\alpha, 1)$$
- $\h_k$:
    $$\h_k \sim \N(\bm{0},\Gamma)$$
- $\lin\mid\w_i$:
    $$p(\lin=k\mid\w_{i}) = w_{ik}$$
- $\w_i$:
    $$\w_i \sim \Dir(a_1,...,a_K)$$


# Joint Posterior
Let $\bm\theta = \p{\bm{\mus, \psi, \tau^2, \bm\pi, \sigma^2, v, h, \lambda, w}}$

$$
\begin{split}
p(\bm\theta \mid K, \y, \alpha) \propto& \bc{\prod_{i=1}^I 
p(\sigma_i^2) p(\bm{w_i})
\prod_{n=1}^{N_i} p(\lambda_{i,n}\mid \bm {w_i})  \prod_{j=1}^J p(y_{inj} \mid 
\mus_{j,\lambda_{i,n}} , \sigma^2_i, z_{j,\lambda_{i,n}}) } \\
&\prod_{j=1}^J p(\tau_j^2) p(\psi_j) \prod_{j=1,k=1}^{J,K}  
%p_{z_{jk}}(\mu^*_{jk} \mid \psi_j, \tau_j^2) 
p(\mus_{jk} \mid \psi_j, \tau_j^2, z_{jk}) 
\prod_{k=1}^Kp(v_k)p(\h_k)
\prod_{i=1,j=1}^{I,J} p(\pi_{ij})
\end{split}
$$

Note that here, $K$ and $\alpha$ are fixed.

# Sampling via MCMC
Sampling can be done via Gibbs sampling by repeatedly updating each parameter
one at a time until convergence. Parameter updates are made by sampling from
it's full conditional distribution. Where this cannot be done conveniently, 
a metropolis step will be necessary.

# Derivation of Full Conditionals

Let $p_1(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2) = 
\logNpdf{y_{inj}}{\mus_{j,\lin}}{\sigma_i^2}$, the log-Normal pdf.

Let $p_0(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2) = 
\pi_{ij} \delta_0(y_{inj}) + 
(1-\pi_{ij})p_1(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2)$.


## Full Conditional for $\bm\mu^*$

Let the prior for $\mu_{jk}^*$ be 

\begin{align*}
\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk}=1 ~~&\sim~~ 
\N(\psi_j, \tau_j^2)\Ind{\mus_{jk} > 0} \\
%
\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk}=0 ~~&\sim~~ 
\N(\psi_j, \tau_j^2)\Ind{\mus_{jk} < 0} \\
\end{align*}

Then,

\begin{align*}
p(\mus_{jk} \mid \y,\rest) \propto&~~ p(\mus_{jk}\mid z_{jk}, \psi_j, \tau_j^2) 
\times 
\prod_{i=1,n=1}^{I,N_i} p(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2, z_{j,\lin})\\
\\
\propto&~~ 
p(\mus_{jk}\mid \psi_j, \tau_j^2, z_{jk}=1)^{\Ind{\mus_{jk}>0}} \times
p(\mus_{jk}\mid \psi_j, \tau_j^2, z_{jk}=0)^{\Ind{\mus_{jk}<0}} \times
\\ &~~
\prod_{i=1}^I\prod_{n=1}^{N_i}
p_1(y_{inj}\mid \mus_{jk}, \sigma_i^2)^{\Ind{\lin=k,~z_{jk}=1}}
p_0(y_{inj}\mid \mus_{jk}, \sigma_i^2)^{\Ind{\lin=k,~z_{jk}=0}}\\
\\
\propto&~~
\bc{
\frac{\exp\bc{-\frac{(\mus_{jk}-\psi_j)^2}{2\tau_j^2}}}
{\Phi\p{\frac{\mus_{jk}-\psi_j}{\tau_j}}}
}^{\Ind{\mus_{jk}>0,~z_{jk}=1}}
\bc{
\frac{\exp\bc{-\frac{(\mus_{jk}-\psi_j)^2}{2\tau_j^2}}}
{1-\Phi\p{\frac{\mus_{jk}-\psi_j}{\tau_j}}}
}^{\Ind{\mus_{jk}<0,~z_{jk}=0}}
\times \\
&~~\prod_{i=1}^I\prod_{n=1}^{N_i}
\exp\bc{-\frac{(\ln(y_{inj})-\mus_{jk})^2}{2\sigma_i^2}}^{\Ind{\lin=k,~z_{jk}=1}}
\times\\
&\bc{\pi_{ij}\delta_0(y_{inj}) + (1-\pi_{ij})
\logNpdf{y_{inj}}{\mus_{jk}}{\sigma_i^2}}^{\Ind{\lin=k,~z_{jk}=0}}
\end{align*}

The full conditional is not available in closed form. But, it can be sampled
from by a Metropolis step with a Normal proposal. More precisely, we sample 
a candidate value $\widetilde{\mus_{jk}}$ from a Normal proposal distribution
centered at the current iterate (say $\mus_{jk}$) of the MCMC. The proposed state
is accepted with probability 

$$
\min\bc{1, \frac{p(\widetilde{\mus_{jk}}\mid \y, \rest)}{p(\mus_{jk}\mid \y, \rest)}}.
$$

## Full Conditional for $\bm\psi$
$\psi_j$ has prior distribution $\psi_j \sim \N(m_\psi, s^2_\psi)$.
So, it's full conditional is 

$$
\begin{split}
p(\psi_j \mid \y, \rest) \propto&~~ p(\psi_j) \times 
\prod_{i=1}^I \prod_{n=1}^{N_i}
p(\mu_{j,\lin}\mid \psi_j, \tau_j^2, z_{j,\lin}) \\
%
\propto&~~ \exp\bc{-\frac{(\psi_j-m_\psi)^2}{2s^2_\psi}} \times 
\\
&~~
\prod_{i=1}^I\prod_{n=1}^{N_i}
\bc{
\frac{\exp\bc{-\frac{(\mus_{j,\lin}-\psi_j)^2}{2\tau_j^2}}}
{\Phi\p{\frac{\mus_{j,\lin}-\psi_j}{\tau_j}}}
}^{\Ind{\mus_{j,\lin}>0,~z_{j,\lin}=1}}
\times \\
&\hspace{4em}\bc{
\frac{\exp\bc{-\frac{(\mus_{j,\lin}-\psi_j)^2}{2\tau_j^2}}}
{1-\Phi\p{\frac{\mus_{j,\lin}-\psi_j}{\tau_j}}}
}^{\Ind{\mus_{j,\lin}<0,~z_{j,\lin}=0}}
\end{split}
$$

The full conditional is not available in closed form. But, it can be sampled
from by a Metropolis step with a Normal proposal. More precisely, we sample 
a candidate value $\tilde{\psi_j}$ from a Normal proposal distribution
centered at the current iterate (say $\psi_j$) of the MCMC. 
The proposed state is accepted with probability 

$$
\min\bc{1, 
\frac{p(\tilde{\psi_{j}}\mid \y, \rest)}
     {p(\psi_{j}\mid \y, \rest)}
}.
$$


## Full Conditional for $\bm{\tau^2}$
Let $\tau_j^2$ have prior distribution $\tau_j^2 \sim \IG(a_\tau, b_\tau)$.
So, it's full conditional is 

$$
\begin{split}
p(\tau_j^2 \mid \y, \rest) \propto&~~ p(\tau_j^2) \times 
\prod_{k=1}^K p(\mu_{jk}\mid \psi_j, \tau_j^2) \\
%
\propto&~~ (\tau_j^2)^{-a_\tau-1} \exp\bc{-b_\tau/\tau_j^2} \times \\
&~~
\prod_{i=1}^I\prod_{n=1}^{N_i}
\bc{
\frac{\exp\bc{-\frac{(\mus_{j,\lin}-\psi_j)^2}{2\tau_j^2}}}
{\Phi\p{\frac{\mus_{j,\lin}-\psi_j}{\tau_j}}}
}^{\Ind{\mus_{j,\lin}>0,~z_{j,\lin}=1}}
\times \\
&\hspace{4em}\bc{
\frac{\exp\bc{-\frac{(\mus_{j,\lin}-\psi_j)^2}{2\tau_j^2}}}
{1-\Phi\p{\frac{\mus_{j,\lin}-\psi_j}{\tau_j}}}
}^{\Ind{\mus_{j,\lin}<0,~z_{j,\lin}=0}}
\end{split}
$$

As the full conditional for $\tau_j^2$ is not available in closed form,
it needs to be approximated. This can be done with a metropolis step
by log-transforming $\tau_j^2$ and using a (symmetric) Normal 
proposal distribution. 

Note that if a random variable $X$ has pdf $f_X(x)$ then $Y = \log(X)$ has pdf
$f_Y(y) = f_X(e^y) e^y$. So, the pdf for $\zeta_i = \log(\tau_j^2)$ is 

$$
\begin{split}
p(\zeta_j) &= \frac{b^a}{\Gamma(a)} (e^{\zeta_j})^{-a-1} \exp\bc{-b/e^{\zeta_j}} e^{\gamma_j}\\
&\propto \exp\bc{-a\zeta_j - be^{-\zeta_j}}
\end{split}
$$

So, the full conditional of $\zeta_j$ is

$$
\begin{split}
p(\zeta_j\mid\y,\rest) \propto&~~ 
\exp\bc{-a_\tau\zeta_j -b_\tau e^{-\zeta_i}}
\times \\
&~~
\prod_{i=1}^I\prod_{n=1}^{N_i}
\bc{
\frac{\exp\bc{-\frac{(\mus_{j,\lin}-\psi_j)^2}{2\exp(\zeta_j)}}}
{\Phi\p{\frac{\mus_{j,\lin}-\psi_j}{\exp(\zeta_j)/2}}}
}^{\Ind{\mus_{j,\lin}>0,~z_{j,\lin}=1}}
\times \\
&\hspace{4em}\bc{
\frac{\exp\bc{-\frac{(\mus_{j,\lin}-\psi_j)^2}{2\exp(\zeta_j)}}}
{1-\Phi\p{\frac{\mus_{j,\lin}-\psi_j}{\exp(\zeta_j)/2}}}
}^{\Ind{\mus_{j,\lin}<0,~z_{j,\lin}=0}}
\end{split}
$$

The parameter $\tau_j^2$ can be updated vicariously by updating $\zeta_j$
and then exponentiating the result. That is, we sample a candidate value for
the parameter $\tilde{\zeta_j}$ from a Normal proposal centered at the current
iterate (say $\zeta_j$) of the MCMC. The proposed state is accepted with 
probability

$$
\min\bc{1, \frac{p(\tilde{\zeta_j}\mid \y,\rest)}
                {p(\zeta_j\mid \y,\rest)}}.
$$



## Full Conditional for $\bm\pi$
The prior for $\pi_{ij} \mid c_j, d$ is $\Be^\star(c_j, d)$. So, the full 
conditional is

$$
\begin{split}
p(\pi_{ij}\mid \y,\rest) \propto&~~ p(\pi_{ij}) \times \\
&~~
\prod_{n=1}^{N_i} 
\bc{
\pi_{ij}\delta_0(y_{inj}) + (1-\pi_{ij})
\logNpdf{y_{inj}}{\mu_{j,\lin}}{\sigma_i^2}
}^{1-z_{j,\lin}}\\
%
\propto&~~ (\pi_{ij})^{c_jd-1}(1-\pi_{ij})^{(1-c_j)d-1} \times \\
&~~\prod_{n=1}^{N_i} 
\bc{
\pi_{ij}\delta_0(y_{inj}) + (1-\pi_{ij})
\logNpdf{y_{inj}}{\mu_{j,\lin}}{\sigma_i^2}
}^{1-z_{j,\lin}}\\
\end{split}
$$

For each $\pi_{ij}$, the full conditional cannot be sampled from conveniently.
So, a metropolis update is required for each $\pi_{ij}$.  This requires
logit-transforming the $\pi_{ij}$'s and using a Normal proposal distribution
centered at the current $\pi_{ij}$ in the metropolis update. Specifically,
if a random variable $X$ has support in the unit interval, the 
$Y=\logit(X)=\log\p{\frac{p}{1-p}}$ will have pdf 
$f_Y(y) = f_X\p{\frac{1}{1+\exp(-y)}}e^{-y}(1+e^{-y})^{-2}$. So, the prior
density for $\xi_{ij} = \logit(\pi_{ij})$ is

$$
p(\xi_{ij} \mid c_j, d) = 
\frac{\Gamma(d)}{\Gamma(c_jd)\Gamma((1-c_j)d)}
\p{\frac{1}{1+\exp(-\xi_{ij})}}^{c_j d -1}
\p{\frac{1}{1+\exp(\xi_{ij})}}^{(1-c_j)d - 1}
\frac{e^{\xi_{ij}}}{\p{1+e^{\xi_{ij}}}^2}
$$

So, the full conditional of $\xi_{ij}$ is

$$
\begin{split}
p(\xi_{ij}\mid\y,\rest) \propto&~~ 
\p{\frac{1}{1+\exp(-\xi_{ij})}}^{c_j d -1}
\p{\frac{1}{1+\exp(\xi_{ij})}}^{(1-c_j)d - 1}
\frac{e^{\xi_{ij}}}{\p{1+e^{\xi_{ij}}}^2}
\times \\
&\prod_{n=1}^{N_i} 
\bc{
\frac{\delta_0(y_{inj})}{1+e^{-\xi_{ij}}} + \p{\frac{1}{1+e^{\xi_{ij}}}}
\logNpdf{y_{inj}}{\mu_{j,\lin}}{\sigma_i^2}
}^{1-z_{j,\lin}}\\
\end{split}
$$

The parameter $\xi_{ij}$ can be updated vicariously by updating $\xi_{ij}$ and
then taking the inverse-logit the result. That is, we sample a candidate value
for the parameter $\tilde{\xi_{ij}}$ from a Normal proposal centered at the
current iterate (say $\xi_{ij}$) of the MCMC. The proposed state is accepted
with probability

$$
\min\bc{1, \frac{p(\tilde{\xi_{ij}}\mid \y,\rest)}
                {p(\xi_{ij}\mid \y,\rest)}}.
$$


## Full Conditional for $\sigma_i^2$

Let $p(\sigma_i^2) \propto (\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)$. 

$$
\begin{split}
p(\sigma_i^2 \mid -) \propto&~~ p(\sigma_i^2) 
\prod_{j=1}^J\prod_{n=1}^{N_i} p(y_{inj} \mid \mu_{j,\lin}^*, \sigma_i^2, z_{j,\lin}) \\
%
\propto&~~ p(\sigma_i^2) 
\prod_{j=1}^K\prod_{n=1}^{N_i}
p_1(y_{inj}\mid\mu_{j,\lin}^* , \sigma^2_i)^{\Ind{z_{j,\lin}=1}} 
p_0(y_{inj}\mid\mu_{j,\lin}^* , \sigma^2_i)^{\Ind{z_{j,\lin}=0}} \\
%
\propto&~~ (\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)\times \\
&\prod_{j=1}^K\prod_{n=1}^{N_i}
\logNpdf{y_{inj}}{\mu_{j,\lin}}{\sigma_i^2}^{\Ind{z_{j,\lin}=1}}
\times\\
&\hspace{1em}
\bc{
\pi_{ij}~\delta_0(y_{inj}) + 
(1-\pi_{ij})\logNpdf{y_{inj}}{\mu_{j,\lin}}{\sigma_i^2} 
}^{\Ind{z_{j,\lin}=0}}
\\
%
\end{split}
$$

As the full conditional for $\sigma_i^2$ is not available in closed form,
it needs to be approximated. This can be done with a metropolis step
by log-transforming $\sigma_i^2$ and using a (symmetric) Normal 
proposal distribution. 

Note that if a random variable $X$ has pdf $f_X(x)$ then $Y = \log(X)$ has pdf
$f_Y(y) = f_X(e^y) e^y$. So, the pdf for $\gamma_i = \log(\sigma_i^2)$ is 

$$
\begin{split}
p(\gamma_i) &= \frac{b^a}{\Gamma(a)} (e^{\gamma_i})^{-a-1} \exp\bc{-b/e^{\gamma_i}} e^{\gamma_i}\\
&\propto \exp\bc{-a\gamma_i - be^{-\gamma_i}}
\end{split}
$$

So, the full conditional of $\gamma_i$ is then

$$
\begin{split}
p(\gamma_i\mid\y,\rest) \propto&~~ 
\exp\bc{-a_\sigma\gamma_i -b_\sigma e^{-\gamma_i}}
\times \\
&\prod_{j=1}^K\prod_{n=1}^{N_i}
\logNpdf{y_{inj}}{\mu_{j,\lin}}{\exp(\gamma_i)}^{\Ind{z_{j,\lin}=1}}
\times\\
&\hspace{1em}
\bc{
\pi_{ij}~\delta_0(y_{inj}) + 
(1-\pi_{ij})\logNpdf{y_{inj}}{\mu_{j,\lin}}{\exp(\gamma_i)}
}^{\Ind{z_{j,\lin}=0}}
\end{split}
$$

The parameter $\sigma_i^2$ can be updated vicariously by updating $\gamma_i$
and then exponentiating the result. That is, we sample a candidate value for
the parameter $\tilde{\gamma_i}$ from a Normal proposal centered at the current
iterate (say $\gamma_i$) of the MCMC. The proposed state is accepted with 
probability

$$
\min\bc{1, \frac{p(\tilde{\gamma_i}\mid \y,\rest)}
                {p(\gamma_i\mid \y,\rest)}}.
$$


[comment]: <> (%
STOPPED HERE FIXME 
%)

---

# ITEMS BELOW NEED TO BE REVISED

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
The prior for $\w_i$ is $w_i \sim \Dir(a_1, \cdots, a_K)$

\begin{align*}
p(\w_i \mid -) \propto&~~ p(\w_i) \times \prod_{n=1}^{N_i} p(\lin \mid \w_i)\\
\propto&~~ p(\w_i) \times \prod_{n=1}^{N_i}\prod_{k=1}^K w_{k}^{\Ind{\lin=k}}\\
\propto&~~ \prod_{k=1}^K w_k^{a_k} \times \prod_{n=1}^{N_i}\prod_{k=1}^K w_{ik}^{\Ind{\lin=k}}\\
\propto&~~ \prod_{k=1}^K w_{ik}^{a_k + \sum_{n=1}^{N_i}\Ind{\lin=k}}\\
%
\end{align*}

Therefore,
$$
(\w_i \mid \bm\lambda_i,-) ~\sim~ \Dir\p{a_1+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=1},...,a_{K}+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=K}} 
$$

Consequently, the full conditional for $\w$ can be sampled from directly.


## Full Conditional for $c_j$

## Full Conditional for $d$


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

