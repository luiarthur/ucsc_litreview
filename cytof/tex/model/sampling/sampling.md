---
title:    "Sampling Scheme for CYTOF Model"
author:   "Arthur Lui"
date:     "\\today"
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
    #- \pagestyle{empty}
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
    - \usepackage{xifthen}
    - \newcommand{\y}{\bm{y}}
    - \newcommand{\yin}{\y_{i,n}}
    - \newcommand{\muin}{\bm{\mu}_{i,n}}
    - \newcommand{\bmu}{\bm{\mu}}
    - \newcommand{\mus}{\mu^\star}
    - \newcommand{\tmus}{{\tilde\mu}^\star}
    - \newcommand{\lin}{{\lambda_{i,n}}}
    - \newcommand{\Z}{\mathbf{Z}}
    - \newcommand{\z}{\bm{z}}
    - \newcommand{\btheta}{{\bm\theta}}
    - \renewcommand{\v}{\bm{v}}
    - \newcommand{\bzero}{\bm{0}}
    - \newcommand{\w}{\bm{w}}
    - \newcommand{\h}{\bm{h}}
    - \newcommand{\LN}{\text{Log-}\N}
    - \newcommand{\IBP}{\text{IBP}}
    - \newcommand{\TN}{\text{TN}}
    - \newcommand{\Unif}{\text{Uniform}}
    - \newcommand{\Dir}{\text{Dirichlet}}
    - \newcommand{\IG}{\text{IG}}
    - \newcommand{\Be}{\text{Beta}}
    - \newcommand{\Bern}{\text{Bernoulli}}
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
    - \newcommand{\sign}[1]{\text{sign}\p{#1}}
    - \newcommand{\logNpdf}[3]{\frac{1}{#1\sqrt{2\pi#3}}\exp\bc{-\frac{\p{\log(#1)-#2}^2}{2{#3}}}}
    - \newcommand{\Npdf}[3]{\frac{1}{\sqrt{2\pi{#3}}}\exp\bc{-\frac{\p{#1-#2}^2}{2#3}}}
    - \newcommand{\Npdfc}[3]{\exp\bc{ -\frac{\p{#1-#2}^2}{2#3} }}
    - \newcommand{\TNpdf}[3]{\frac{\Npdf{#1}{#2}{{#3}^2}}{\Phi\p{\frac{#1-#2}{#3}}}}
    - \newcommand{\TNpdm}[3]{\frac{\Npdf{#1}{#2}{{#3}^2}}{1-\Phi\p{\frac{#1-#2}{#3}}}}
    - \newcommand{\TNpdfc}[3]{\frac{\Npdfc{#1}{#2}{{#3}^2}}{\Phi\p{\frac{#1-#2}{#3}}}}
    - \newcommand{\TNpdfcm}[3]{\frac{\Npdfc{#1}{#2}{{#3}^2}}{1-\Phi\p{\frac{#1-#2}{#3}}}}
    - \newcommand{\rest}{\text{rest}}
    - \newcommand{\logit}{\text{logit}}
    - \newcommand{\piconsta}{\frac{\exp(\rho)}{1+\exp(-\kappa_j)}}
    - \newcommand{\piconstb}{\frac{\exp(\rho)}{1+\exp( \kappa_j)}}
    - \newcommand{\piconst}{\frac{\Gamma(\exp(\rho))}{\Gamma\p{\piconsta}\Gamma\p{\piconstb}}}
    - \newcommand{\likeone}[1][]{
        \bc{\delta_0(y_{inj})}^{\Ind{e_{inj}=1#1}}
      }
    - \newcommand{\likezero}[2][]{
        \bc{
        \TNpdf{y_{inj}}{\mus_{j#2}}{\sigma_i}
        }^{\Ind{e_{inj}=0#1}}
      }
    - \newcommand{\likezeroc}[2][]{
        \bc{
          \frac{
            \exp\bc{\frac{(y_{inj}-\mus_{j#2})^2}{2 \sigma^2_i}}
          }{
            \Phi\p{\frac{y_{inj}-\mus_{j#2}}{\sigma_i}}
          }
        }^{\Ind{e_{inj}=0#1}}
      }
    - \newcommand{\pone}[1]{
        p(y_{inj}\mid \mus_{j,#1}, \sigma_i^2, e_{inj}=1)
      }
    - \newcommand{\sumjn}{\sum_{j=1}^J\sum_{n=1}^{N_i}}
    - \newcommand{\pmugt}[2][]{
        \bc{
          \frac{
            \Npdf{\mus_{j,#2}}{\psi_j}{\tau_j^2}
          }{
            1-\Phi\p{ \frac{\mus_{j,#2}-\psi_j-\log(2)}{\tau_j} }
          }
        }^{\Ind{
            \ifthenelse{\equal{#1}{}}{
              \mus_{j,#2}>\log(2),~z_{j#2}=1
            }{#1}
          }
        }
      }
    - \newcommand{\pmult}[2][]{
        \bc{
          \frac{
            \Npdf{\mus_{j,#2}}{\psi_j}{\tau_j^2}
          }{
            \Phi\p{ \frac{\mus_{j,#2}-\psi_j-\log(2)}{\tau_j} }
          }
        }^{\Ind{
            \ifthenelse{\equal{#1}{}}{
              \mus_{j,#2}<\log(2),~z_{j#2}=0
            }{#1}
          }
        }
      }
    - \newcommand{\pmugtc}[2][]{
        \bc{
          \frac{
            \exp\bc{-\frac{(\mus_{j,#2}-\psi_j)^2}{2\tau_j^2}}
          }{
            1-\Phi\p{ \frac{\mus_{j,#2}-\psi_j-\log(2)}{\tau_j} }
          }
        }^{\Ind{
            \ifthenelse{\equal{#1}{}}{
              \mus_{j,#2}>\log(2),~z_{j#2}=1
            }{#1}
          }
        }
      }
    - \newcommand{\pmultc}[2][]{
        \bc{
          \frac{
            \exp\bc{-\frac{(\mus_{j,#2}-\psi_j)^2}{2\tau_j^2}}
          }{
            \Phi\p{ \frac{\mus_{j,#2}-\psi_j-\log(2)}{\tau_j} }
          }
        }^{\Ind{
            \ifthenelse{\equal{#1}{}}{
              \mus_{j,#2}<\log(2),~z_{j#2}=0
            }{#1}
          }
        }
      }
    - \input{mh.tex}
---


# Sampling Distribution

$$
\begin{array}{lcl}
p(y_{inj} \mid \mus_{j,\lin}, \sigma^2_i, e_{inj}) &=&
\begin{cases}
\delta_0(y_{inj}) & \text{if } e_{inj}=1 \\
\TNpdf{y_{inj}}{\mus_{j,\lin}}{\sigma_i}, & \text{if } e_{inj}=0 \\
\end{cases}
\\
\\
e_{inj} \mid z_{j,\lin}=0,\pi_{ij} &\sim& \Bern(\pi_{ij}) \\
e_{inj} \mid z_{j,\lin}=1          &:=& 0 \\
\end{array}
$$

## Marginal Sampling Distribution

$$
\begin{split}
p(y_{inj} \mid \mus_{jk},\sigma_i^2, z_{j,\lin}=1) 
&=~
\TNpdf{y_{inj}}{\mus_{j,\lin}}{\sigma_i}
\\
%%%
p(y_{inj} \mid  \mus_{j,\lin},\sigma_i^2, z_{j,\lin}=0, \pi_{ij})
&=~
\pi_{ij}\delta_0(y_{inj}) + 
(1-\pi_{ij}) \TNpdf{y_{inj}}{\mus_{j,\lin}}{\sigma_i}
\\
\end{split}
$$

# Priors

- $\mus_{jk}$:
$$\begin{cases}
p(\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk}=1) ~~&=~~ 
\pmugt[\mus_{jk} > \log(2)]{k} \\
%
p(\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk}=0) ~~&=~~ 
\pmult[\mus_{jk} < \log(2)]{k} \\
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
Let $\bm\theta = (\bm{\theta_1, \theta_2})$, where

- $\theta_1=(\bm{\psi, \tau^2, \sigma^2, \pi})$ are the parameters
  that do not depend on $K$, and
- $\theta_2=(\bm{\mus, v, h, \lambda, w, e})$ are the parameters
  that depend on $K$.

$$
\begin{split}
p(\bm\theta \mid K, \y, \alpha) \propto& \bc{\prod_{i=1}^I 
p(\sigma_i^2) p(\bm{w_i})
\prod_{n=1}^{N_i} p(\lambda_{i,n}\mid \bm {w_i})  \prod_{j=1}^J p(y_{inj} \mid 
\mus_{j,\lambda_{i,n}} , \sigma^2_i, e_{inj}) } \\
&\prod_{j=1}^J p(\tau_j^2) p(\psi_j) \prod_{j=1,k=1}^{J,K}  
%p_{z_{jk}}(\mu^*_{jk} \mid \psi_j, \tau_j^2) 
p(\mus_{jk} \mid \psi_j, \tau_j^2, z_{jk}) 
\prod_{k=1}^Kp(v_k)p(\h_k)\\
%
&\prod_{i=1,j=1}^{I,J} p(\pi_{ij} \mid c_j, d)
\prod_{j=1}^J p(c_j) p(d)\times\\
%
&
\prod_{i=1,n=1,j=1}^{I,N_i,J} p(e_{inj} \mid z_{j,\lin}=0)\\
\end{split}
$$

Note that here, $K$ and $\alpha$ are fixed.

# Sampling via MCMC
Sampling can be done via Gibbs sampling by repeatedly updating each parameter
one at a time until convergence. Parameter updates are made by sampling from
it full conditional distribution. Where this cannot be done conveniently, 
a metropolis step will be necessary.

To sample from a distribution which is otherwise difficult to sample from, the
Metropolis-Hastings algorithm can be used. This is particularly useful when
sampling from a full conditional distribution of one of many parameters in an
MCMC based sampling scheme (such as a Gibbs sampler). Say $B$ samples from a
distribution with density $p(\theta)$ is desired, one can do the following:

1. Provide an initial value for the sampler, e.g. $\theta^{(0)}$.
2. Repeat the following steps for $i = 1,...,B$.
3. Sample a new value $\tilde\theta$ for $\theta^{(i)}$ from a proposal 
   distribution $Q(\cdot \mid \theta^{(i-1)})$.
     - Let $q(\tilde\theta \mid \theta)$ be the density of the
       proposal distribution.
4. Compute the "acceptance ratio" to be 
   $$
   \rho=
   \min\bc{1, \frac{p(\tilde\theta)}{p(\theta^{(i-1)})} \Big/ 
              \frac{q(\tilde\theta\mid\theta^{(i-1)})}
                   {q(\theta^{(i-1)}\mid\tilde\theta)}
          }
   $$
5. Set 
   $$
   \theta^{(i)} := 
   \begin{cases}
   \tilde\theta &\text{with probability } \rho \\
   \theta^{(i-1)} &\text{with probability } 1-\rho.
   \end{cases}
   $$

Note that in the case of a symmetric proposal distribution, the 
acceptance ratio simplifies further to be 
$\frac{p(\tilde\theta)}{p(\theta^{(i-1)})}$.

The proposal distribution should be chosen to have the same support
as the parameter. Transforming parameters to have infinite support
can, therefore, be convenient as a Normal proposal distribution
can be used. Moreover, as previously mentioned, the use of symmetric proposal
distributions (such as the Normal distribution) can simplify the 
computation of the acceptance ratio.

Some common parameter transformations are therefore presented here:

1. For parameters bounded between $(0,1)$, a logit-transformation
   may be used.  Specifically, if a random variable $X$ with density $f_X(x)$
   has support in the unit interval, then $Y=\logit(X)=\log\p{\frac{p}{1-p}}$
   will have density 
   $f_Y(y) = f_X\p{\frac{1}{1+\exp(-y)}}\frac{e^{-y}}{(1+e^{-y})^{2}}$.
2. For parameters with support $(0,\infty)$, a log-transformation
   may be used.  Specifically, if a random variable $X$ with density $f_X(x)$
   has positive support, then $Y = \log(X)$ has pdf
   $f_Y(y) = f_X(e^y) e^y$.


# Derivation of Full Conditionals


## Full Conditional for $\bm\mu^*$

\begin{align*}
p(\mus_{jk} \mid \y,\rest) \propto&~~ p(\mus_{jk}\mid \psi_j, \tau_j^2, z_{jk}) 
\times 
\prod_{i=1,n=1}^{I,N_i}
\bc{p(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2, e_{inj})}^{\Ind{\lin=k}}\\
\\
\propto&~~
\pmugtc{k}
\times \\
&~~
\pmultc{k}
\times \\
&~~\prod_{i=1}^I\prod_{n=1}^{N_i}
\likezeroc[,~\lin=k]{k}
\end{align*}

\mhSpiel{\mus_{jk}}

## Full Conditional for $\bm\psi$
$\psi_j$ has prior distribution $\psi_j \sim \N(m_\psi, s^2_\psi)$.
So, its full conditional is 

$$
\begin{split}
p(\psi_j \mid \y, \rest) \propto&~~ p(\psi_j) \times 
\prod_{k=1}^K 
p(\mu_{j,k}\mid \psi_j, \tau_j^2, z_{j,k}) \\
%
\propto&~~ \exp\bc{-\frac{(\psi_j-m_\psi)^2}{2s^2_\psi}} \times 
\\
&~~
\prod_{k=1}^K
\pmugtc[z_{jk}=1]{k}
\times \\
&\hspace{2em}
\pmultc[z_{jk}=0]{k}
\end{split}
$$

\mhSpiel{\psi_j}


## Full Conditional for $\bm{\tau^2}$
Let $\tau_j^2$ have prior distribution $\tau_j^2 \sim \IG(a_\tau, b_\tau)$.
So, its full conditional is 

$$
\begin{split}
p(\tau_j^2 \mid \y, \rest) \propto&~~ p(\tau_j^2) \times 
\prod_{k=1}^K p(\mu_{jk}\mid \psi_j, \tau_j^2) \\
%
\propto&~~ (\tau_j^2)^{-a_\tau-1} \exp\bc{-b_\tau/\tau_j^2} \times \\
&~~
\prod_{k=1}^K
\pmugt[z_{jk}=1]{k}
\times \\
&\hspace{4em}
\pmult[z_{jk}=0]{k}
\end{split}
$$

\mhLogSpiel{{\tau_j^2}}{{\zeta_j}}


## Full Conditional for $\bm\pi$
The prior for $\pi_{ij} \mid c_j, d$ is $\Be^\star(c_j, d)$. So, the full 
conditional is

$$
\begin{split}
p(\pi_{ij}\mid \y,\rest) \propto&~~ p(\pi_{ij}) \times
\prod_{n=1}^{N_i} 
p(e_{inj} \mid z_{j,\lin}, \pi_{ij})^{1-z_{j,\lin}}
\\
%
\propto&~~ (\pi_{ij})^{c_jd-1}(1-\pi_{ij})^{(1-c_j)d-1} \times \\
&~~\prod_{n=1}^{N_i} 
\bc{
\pi_{ij}^{e_{inj}}
(1-\pi_{ij})^{1-e_{inj}}
}^{1-z_{j,\lin}}\\
%
\propto&~~ (\pi_{ij})^{c_jd-1}(1-\pi_{ij})^{(1-c_j)d-1} \times \\
&~~
\bc{
\pi_{ij}^{\sum_{n=1}^{N_i} e_{inj}\p{1-z_{j,\lin}}}
(1-\pi_{ij})^{\sum_{n=1}^{N_i} \p{1-e_{inj}}\p{1-z_{j,\lin}}}
}\\
%
\propto&~~
(\pi_{ij})^{c_jd+\p{\sum_{n=1}^{N_i} e_{inj}\p{1-z_{j,\lin}}}-1}
(1-\pi_{ij})^{(1-c_j)d+\p{\sum_{n=1}^{N_i} \p{1-e_{inj}}\p{1-z_{j,\lin}}}-1}
\\
\end{split}
$$

Therefore, we can sample from the full conditional by sampling
from

$$
\pi_{ij} \mid \y, \rest \sim 
\Be\p{
c_jd+\p{\sum_{n=1}^{N_i} e_{inj}\p{1-z_{j,\lin}}},
(1-c_j)d+\p{\sum_{n=1}^{N_i} \p{1-e_{inj}}\p{1-z_{j,\lin}}}
}
$$

## Full Conditional for $\sigma_i^2$

Let $p(\sigma_i^2) \propto (\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)$. 

\begin{align*}
p(\sigma_i^2 \mid -) \propto&~~ p(\sigma_i^2) 
\prod_{j=1}^J\prod_{n=1}^{N_i}
p(y_{inj} \mid \mu_{j,\lin}^*, \sigma_i^2, e_{inj}) \\
%
\propto&~~ (\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)\times \\
&\prod_{j=1}^J\prod_{n=1}^{N_i}
\likeone
\times\\
&\hspace{1em}
\likezero{\lin} \\
\\
%
\propto&~~
(\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)\times \\
&\prod_{j=1}^J\prod_{n=1}^{N_i}
\likezero{\lin} \\
%
\\
\end{align*}

\mhLogSpiel{{\sigma_i^2}}{{\xi_i}}



## Full Conditional for $\v$

The prior distribution for $v_k$ are $v_k \mid \alpha \ind \Be(\alpha, 1)$, for 
$k = 1,...,K$. So, $p(v_k \mid \alpha) = \alpha v_k^{\alpha-1}$. 

Note that, if $\mus_{jk}>\log(2)$ then $z_{jk}=1$ by definition, which in turn
affects $v_k$. This behavior is undesirable. So, we will jointly update
$\mus_{jk}$ and $v_k$. More accurately, we will jointly update $(\bm\mus_{k:K},
\phi_k)$, where $\phi_k$ is the logit-transformation of the parameter $v_k$.

The full conditional for $(\phi_k, \mus_{j,k:K})$ is:
$$
\begin{split}
p(\phi_k, \mus_{k:K} \mid \y, \rest) 
&\propto
p(\phi_k) \times
\prod_{j=1}^J \prod_{l=k}^K 
p(\mus_{jl}\mid\psi_j, \tau^2_j, z_{jl}) \times \\
%&~~
%\prod_{i=1}^I \prod_{n=1}^{N_i} \prod_{j=1}^J 
%p(e_{inj} \mid z_{j,\lin}, \pi_{ij})^{\Ind{\lin \ge k,~z_{j,\lin}=0}} 
%\times \\
%%% MARGINALIZE OVER e_{inj} INTEAD
&~~
\prod_{i=1}^I \prod_{n=1}^{N_i} \prod_{j=1}^J 
p(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2, z_{j,\lin}, \pi_{ij})^{\Ind{\lin\ge k}}
\end{split}
$$

Since the full conditional cannot be sampled from directly, a metropolis update
is required. Let $Q_1$ be the proposal distribution. The proposal mechanism
will be as follows:

1. Given the current state $(\phi_k, \bm\mus_{k:K})$,
   sample a proposed state $\tilde\phi_k$ from $\N(\cdot \mid \phi_k, \Sigma_\phi)$ 
   for $\phi_k$, where $\Sigma_\phi$ is some positive real number to be tuned.
2. Compute the new $z_{jl}$ (from the updated $\phi_k \Rightarrow v_k$) 
   for $j = 1,...,J$ and $l=k,...,K$.
3. If $z_{jl}$ is unchanged, then the proposed state for $\mus_{jl}$ is simply
   its current state. Otherwise, the proposed state is 
   $\tmus_{jl} \sim \N(\cdot \mid \psi_j, \tau_j^2, \tilde z_{jl})$ 
4. Compute the proposal density as 
   $$
   \begin{split}
   q_1((\tilde{\phi}_k, \tilde\mus_{j,k:K}) \mid (\phi_k, \mus_{j,k:K}))
   =
   \Npdf{\tilde\phi_k}{\phi_k}{\Sigma_\phi} \times  \\
   \prod_{j=1}^J \prod_{l=k}^{K}
   p(\tilde\mus_{jl} \mid \psi_j, \tau_j^2, \tilde z_{jl})^{\Ind{\tilde z_{jl} \ne z_{jl}}}
   \end{split}
   $$
5. The proposed state $(\tilde\phi_k, \bm\tmus_{k:K})$ will be
   accepted with probability 
   $$\min(1, \Lambda)$$ where
   \begin{align*}
     \Lambda &= 
     \frac{
       p(\tilde\phi_k, \bm\tmus_{k:K} \mid \y, \rest) 
       \times
       q_1(\phi_k, \bm\mus_{k:K} \mid 
       \tilde\phi_k, \bm\tmus_{k:K}) 
     }{
       p(\phi_k, \bm\mus_{k:K} \mid \y, \rest) 
       \times
       q_1( \tilde\phi_k, \bm\tmus_{k:K} \mid 
       \phi_k, \bm\mus_{k:K} )
     }
     \\
     \\
     %%%%%%
     &=
     \frac{p(\tilde\phi_k)}{p(\phi_k)}
     \prod_{j=1}^J\prod_{l=k}^K
     \frac{
       p(\tmus_{jl} \mid \psi_j, \tau_j^2, \tilde z_{jl})
     }{
       p(\mus_{jl} \mid \psi_j, \tau_j^2, z_{jl})
     }
     \times
     \\
     &~~~
     \prod_{i=1}^I\prod_{n=1}^{N_i}\prod_{j=1}^J
     \frac{
      p(y_{inj} \mid \tmus_{j,\lin}, \sigma_i^2, \tilde z_{j,\lin}, \pi_{ij})^{
      \Ind{\lin\ge k}}
     }{
      p(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2, z_{j,\lin}, \pi_{ij})^{
      \Ind{\lin\ge k}}
     }
     \times
     \\
     &~~~
     \frac{q_1(\phi_k \mid \tilde\phi_k)}
          {q_1(\tilde\phi_k \mid \phi_k)}
     \prod_{j=1}^J\prod_{l=k}^K
     \bc{
       \frac{
         p(\mus_{jl} \mid \psi_j, \tau_j^2, z_{jl})
       }{
         p(\tmus_{jl} \mid \psi_j, \tau_j^2, \tilde z_{jl})
       }
     }^{\Ind{z_{jl} \ne \tilde z_{jl}}}
     \\
     \\
     %%%%%%
     %%%%%% CRUX!!!
     &=
     \frac{p(\tilde\phi_k)}{p(\phi_k)}
     \times
     \prod_{i=1}^I\prod_{n=1}^{N_i}\prod_{j=1}^J
     \frac{ % LIKELIHOOD
      p(y_{inj} \mid \tmus_{j,\lin}, \sigma_i^2, \tilde z_{j,\lin}, \pi_{ij})^{
      \Ind{\lin\ge k}}
     }{
      p(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2, z_{j,\lin}, \pi_{ij})^{
      \Ind{\lin\ge k}}
     }
     \\
     \\
     %%%%%%
     &=
     \frac{p(\tilde\phi_k)}{p(\phi_k)}
     \prod_{\bc{(i,n,j): \lin \ge k}}
     \frac{ % LIKELIHOOD
      p(y_{inj} \mid \tmus_{j,\lin}, \sigma_i^2, \tilde z_{j,\lin}, \pi_{ij})
     }{
      p(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2, z_{j,\lin}, \pi_{ij})
     }
     \\\\
     &=
     \exp(\phi_k - \tilde\phi_k)
     \p{\frac{1+\exp(-\phi_k)}{1+\exp(-\tilde\phi_k)}}^{\alpha+1}
     \times \\
     %%% LIKELIHOOD %%%
     &
     \prod_{\bc{(i,n,j):~\lin \ge k,~\tilde z_{j,\lin}=1,~z_{j,\lin}=0}}
     \p{
       \frac{ % LIKELIHOOD
         \TNpdf{y_{inj}}{\tmus_{j,\lin}}{\sigma_i}
       }{
         \pi_{ij} \delta_0(y_{inj}) + (1-\pi_{ij})
         \TNpdf{y_{inj}}{\mus_{j,\lin}}{\sigma_i}
       }
     } \times
     \\\\
     &
     \prod_{\bc{(i,n,j):~\lin \ge k,~\tilde z_{j,\lin}=0,~z_{j,\lin}=1}}
     \p{
       \frac{ % LIKELIHOOD
         \pi_{ij} \delta_0(y_{inj}) + (1-\pi_{ij})
         \TNpdf{y_{inj}}{\tmus_{j,\lin}}{\sigma_i}
       }{
         \TNpdf{y_{inj}}{\mus_{j,\lin}}{\sigma_i}
       }
     }
     %%% END OF LIKELIHOOD $$$
     \\\\
   \end{align*}
   To obtain the new state for $v_k$, we simply need to take the 
   inverse-logit transformation of $\phi_k$.

Note that $z_{jl}$ for $l \ge k$ is a function of $v_k$. Therefore, 
$\tilde z_{jl} = 
\Ind{\Phi(h_{jk} \mid 0, \Gamma_{jj}) < \prod_{l=1}^k \tilde v_l}$ needs to be
evaluated in the expressions above. Note also that since $e_{inj}$ was
marginalized over in the computations above, it is implicitly changed when
the proposed $v_k$ is accepted. Consequently, $e_{inj}$ needs to be updated
after $v_k$ is updated. However, the update can be done any time before 
a parameter which depends on $e_{inj}$ is updated in the MCMC iteration. 
A suitable time scheme would therefore be to updated $\h_k$ immediately after
updating $v_k$, then update $e_{inj}$ immediately after. (See 5.9 for updating
$e_{inj}$.)

## Full Conditional for $\h$
The prior for $\h_k$ is $\h_k \sim \N_J(0, \Gamma)$.
Using Normal theory, we can find the conditional distribution 
$h_{j,k} \mid \h_{-j,k}$, which is 

$$
h_{jk}  \mid \h_{-j,k} \sim \N(m_j, S^2_j),
$$

where

$$
\begin{cases}
m_j &= \Gamma_{j,-j}\Gamma_{-j,-j}^{-1}(\h_{-j,k})\\
S_j^2 &= \Gamma_{j,j} - \Gamma_{j,-j}\Gamma_{-j,-j}^{-1}\Gamma_{-j,j}\\
\end{cases}
$$

and the notation $\h_{-j,k}$ refers to the vector $h_k$ excluding the element in
the $j^{th}$ position. Likewise, $\Gamma_{-j,k}$ refers to the $k^{th}$ column 
of the matrix $\Gamma$ excluding the $j^{th}$ row.

Note again that if $\mus_{jk}>0$, then $z_{jk}=1$ by definition, which in turn
affects $\h_k$. So, we will jointly update $\mus_{jk}$ and $\h_k$. 

The full conditional for $(\h_{jk}, \mus_{jk})$ is:
$$
\begin{split}
&p(h_{jk}, \mus_{jk} \mid \h_{-j,k}, \y, \rest) 
\\
\\
\propto~&
p(h_{jk}\mid \h_{-j,k}) \times
p(\mus_{jk}\mid\psi_j, \tau^2_j, z_{jk}) \times \\
&
\prod_{i=1}^I \prod_{n=1}^{N_i}
\bc{
  p(e_{inj} \mid z_{j,\lin}, \pi_{ij})^{\Ind{\lin = k,~z_{j,\lin}=0}}
  p(y_{inj} \mid \mus_{jk}, \sigma_i^2, e_{inj}) ^ {\Ind{\lin=k}}
}
\\
\\
%%%%%%%%
\propto~&
\Npdfc{h_{jk}}{m_j}{S_j^2}
\times \\
& \pmugtc{k} \pmultc{k} \times \\
&
\prod_{(i,n):\lin=k}
\bc{
  \p{
    \pi_{ij}^{e_{inj}}
    \p{1-\pi_{ij}}^{1-e_{inj}}
  }^{\Ind{z_{j,\lin}=0}}
  \times
  \likezeroc{k} 
}\\
\end{split}
$$

Since the full conditional cannot be sampled from directly, a metropolis update
is required. Let $Q_2$ be the proposal distribution. The proposal mechanism
will be as follows:

1. Given the current state $(h_{jk}, \mus_{jk})$,
   sample a proposed state $\tilde h_{jk}$ from $\N(\cdot \mid h_{jk}, \Sigma_h)$ 
   for $h_{jk}$, where $\Sigma_h$ is some covariance matrix to be tuned.
2. Compute the new $\tilde z_{jk}$ (from the updated $h_{jk}$).
3. If $z_{jk}$ is unchanged, then the proposed state for $\mus_{jk}$ is simply
   its current state. Otherwise, the proposed state is 
   $\tmus_{jk} \sim \N(\cdot \mid \psi_j, \tau_j^2, \tilde z_{jk})$ 
4. Compute the proposal density as 
   $$
   \begin{split}
   q_2(\tilde h_{jk}, \tmus_{jk} \mid h_{jk}, \mus_{jk})
   &\propto~
   \Npdfc{\tilde h_{jk}}{h_{jk}}{\Sigma_h} \times
   p(\tmus_{jk} \mid \psi_j, \tau_j^2, \tilde z_{jk})^{\Ind{\tilde z_{jk} \ne z_{jk}}}
   \\
   \end{split}
   $$
5. The proposed state $(\tilde h_{jk}, \tmus_{jk})$ will be
   accepted with probability 
   $$ \min\bc{1, \Lambda }, $$ where
   \begin{align*}
   \Lambda &=
   \frac{
     p(\tilde h_{jk}, \tmus_{jk} \mid \y, \rest) 
     \times
     q_2( h_{jk}, \mus_{jk} \mid 
     \tilde h_{jk}, \tmus_{jk}) 
   }{
     p(h_{jk}, \mus_{jk} \mid \y, \rest) 
     \times
     q_2( \tilde h_{jk}, \tmus_{jk} \mid 
     h_{jk}, \mus_{jk} )
   }\\
   %%%%%%%%%
   &= \frac{
     p(\tilde  h_{jk} \mid \tilde \h_{-jk})
     p(\tmus_{jk} \mid \psi_j, \tau^2_j, \tilde z_{jk})
   }{
     p(h_{jk} \mid \h_{-jk})
     p(\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk})
   }
   \times 
   \\ &~~~~
   \prod_{(i,n,j):\lin=k}
   \frac{
     %p(e_{inj} \mid \tilde z_{j,\lin}, \pi_{ij})^{1-\tilde z_{j,\lin}}
     %p(y_{inj} \mid \tmus_{jk}, \sigma_i^2, e_{inj})
     p(y_{inj} \mid \tmus_{jk}, \sigma_i^2, \pi_{ij}, \tilde z_{j,\lin})
   }{
     %p(e_{inj} \mid z_{j,\lin}, \pi_{ij})^{1-z_{j,\lin}}
     %p(y_{inj} \mid \mus_{jk}, \sigma_i^2, e_{inj})
     p(y_{inj} \mid \mus_{jk}, \sigma_i^2, \pi_{ij}, z_{j,\lin})
   }
   \times
   \\ &~~~~
   \frac{
     \Npdf{h_{jk}}{\tilde h_{jk}}{\Sigma_h}
   }{
     \Npdf{\tilde h_{jk}}{h_{jk}}{\Sigma_h}
   }
   \bc{
   \frac{
     p(\mus_{jk} \mid \psi_j, \tau_j^2, z_{jk})
   }{
     p(\tmus_{jk} \mid \psi_j, \tau_j^2, \tilde z_{jk})
   }
   }^{\Ind{z_{jk}\ne \tilde z_{jk}}}
   \\
   \\ 
   %%%%%%%%%%%%%%%
   %%%% CRUX !!!
   &= \frac{
     p(\tilde  h_{jk} \mid \tilde \h_{-jk})
   }{
     p(h_{jk} \mid \h_{-jk})
   }
   \times 
   \prod_{\bc{(i,n,j):\lin=k}}
   \frac{
     p(y_{inj} \mid \tmus_{jk}, \sigma_i^2, \pi_{ij}, \tilde z_{j,\lin})
   }{
     p(y_{inj} \mid \mus_{jk}, \sigma_i^2, \pi_{ij}, z_{j,\lin})
   }
   \\
   \\
   %%%%%%%%%%%%%%%
   &=
   \exp\bc{
     -\frac{(\tilde h_{jk} - m_j)^2 - (h_{jk} - m_j)^2}
           {2 S_j}
   }
   \times \\
   &\prod_{\bc{(i,n,j):\lin=k,~\tilde z_{j,\lin} \ne z_{j,\lin}}}
   \frac{
     p(y_{inj} \mid \tmus_{jk}, \sigma_i^2, \pi_{ij}, \tilde z_{j,\lin})
   }{
     p(y_{inj} \mid \mus_{jk}, \sigma_i^2, \pi_{ij}, z_{j,\lin})
   }
   \\
   \\
   &=
   \exp\bc{
     -\frac{(\tilde h_{jk} - m_j)^2 - (h_{jk} - m_j)^2}
           {2 S_j}
   }
   \times \\
   %%% LIKELIHOOD %%%
   &
   \prod_{\bc{(i,n,j):~\lin = k,~\tilde z_{j,\lin}=1,~z_{j,\lin}=0}}
   \p{
     \frac{ % LIKELIHOOD
       \TNpdf{y_{inj}}{\tmus_{j,\lin}}{\sigma_i}
     }{
       \pi_{ij} \delta_0(y_{inj}) + (1-\pi_{ij})
       \TNpdf{y_{inj}}{\mus_{j,\lin}}{\sigma_i}
     }
   } \times
   \\\\
   &
   \prod_{\bc{(i,n,j):~\lin = k,~\tilde z_{j,\lin}=0,~z_{j,\lin}=1}}
   \p{
     \frac{ % LIKELIHOOD
       \pi_{ij} \delta_0(y_{inj}) + (1-\pi_{ij})
       \TNpdf{y_{inj}}{\tmus_{j,\lin}}{\sigma_i}
     }{
       \TNpdf{y_{inj}}{\mus_{j,\lin}}{\sigma_i}
     }
   }
   %%% END OF LIKELIHOOD $$$
   \\\\
   \end{align*}
6. Update $e_{inj}$.


## Full Conditional for $\bm\lambda$

The prior for $\lin$ is $p(\lin = k \mid \w_i) = w_{ik}$.

$$
\begin{split}
p(\lin=k\mid \y,\rest) \propto&~~ %p(\lin=k \mid \w_i)
%\times
\\
&\hspace{-8em}
w_{ik}
\prod_{j=1}^J
\bc{
  \pi_{ij}\delta_0(y_{inj}) + 
  (1-\pi_{ij})
  \TNpdf{y_{inj}}{\mus_{j,k}}{\sigma_i}
}^{\Ind{z_{j,k}=0}} \times \\
&\hspace{-5em}
\bc{
  \TNpdfc{y_{inj}}{\mus_{j,k}}{\sigma_i} }^{\Ind{z_{j,k}=1}}
\end{split}
$$

## Full Conditional for $e_{inj}$

First note that for $z_{j,\lin}=1$,
$$
e_{inj} \mid (z_{j,\lin}=1, \pi_{ij}, \rest) := 0.\\
$$

For $z_{j,\lin}=0$,

\begin{align*}
p(e_{inj} = 1\mid z_{j,\lin}=0, \pi_{ij}, \rest)
=&~
\frac{
p(e_{inj}=1 \mid z_{j,\lin}=0, \pi_{ij})
\times
p(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2, e_{inj}=1)
}{
\sum_{x\in\bc{0,1}}
p(e_{inj}=x \mid z_{j,\lin}=0, \pi_{ij})
\times
p(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2, e_{inj}=x)
} \\
%
\\
\propto&~
\pi_{ij}\likeone
\\
\end{align*}

Similarly,
$$
p(e_{inj} = 0\mid z_{j,\lin}=0, \pi_{ij}, \rest)
\propto
(1-\pi_{ij}) \likezero{\lin}
$$


Since $\lin$ has a discrete support, its full conditional can be sampled from
by sampling one number from $1,...,K$ with probabilities proportional to the
full conditional evaluated at $k\in\bc{1,...,K}$.

## Full Conditional for $\w$
The prior for $\w_i$ is $w_i \sim \Dir(a_1, \cdots, a_K)$. So the full
conditional for $\w_i$ is:

\begin{align*}
p(\w_i \mid \rest) \propto&~~ p(\w_i) \times \prod_{n=1}^{N_i} p(\lin \mid \w_i)\\
\propto&~~ p(\w_i) \times \prod_{n=1}^{N_i}\prod_{k=1}^K w_{k}^{\Ind{\lin=k}}\\
\propto&~~ \prod_{k=1}^K w_k^{a_k} \times \prod_{n=1}^{N_i}\prod_{k=1}^K w_{ik}^{\Ind{\lin=k}}\\
\propto&~~ \prod_{k=1}^K w_{ik}^{a_k + \sum_{n=1}^{N_i}\Ind{\lin=k}}\\
%
\end{align*}

Therefore,
$$
(\w_i \mid \bm\lambda_i,K,\y,\rest) ~\sim~ \Dir\p{a_1+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=1},...,a_{K}+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=K}} 
$$

Consequently, the full conditional for $\w_i$ can be sampled from directly from a Dirichlet distribution of the form above.

## Full Conditional for $c_j$
For notational convenience, note that $\kappa_j = \logit(c_j)$ and
$\rho = \log(d)$. This implies that $c_j = \frac{1}{1+\exp(-\kappa_j)}$
and $d=\exp(\rho)$.

The prior for $\kappa_j = \logit(c_j)$ is $\kappa_j \ind \N(0, s^2_c)$. 
The full conditional for $\kappa_j$ is then:

\begin{align*}
p(\kappa_j \mid \rest) 
\propto&~~ 
p(\kappa_j)\times
\prod_{i=1}^{I} p(\pi_{ij} \mid c_j, d)\\
%
\propto&~~ 
\exp\p{-\frac{\kappa_j^2}{2s_c^2}}
\times \\
&~~ 
\prod_{i=1}^{I}
\piconst (\pi_{ij})^{\piconsta-1} (1-\pi_{ij})^{\piconstb-1} \\
\\
%
\propto&~~ 
\exp\p{-\frac{\kappa_j^2}{2s_c^2}}
\prod_{i=1}^{I}
\frac{(\pi_{ij})^{\piconsta}(1-\pi_{ij})^{\piconstb}}{\Gamma(\piconsta)\Gamma(\piconstb)}
%
\end{align*}

The parameter $c_j$ can be updated by updating $\kappa_j$ and
then taking the inverse-logit the result. That is, we sample a candidate value
for the parameter $\tilde{\kappa_j}$ from a Normal proposal centered at the
current iterate (say $\kappa_j$) of the MCMC. The proposed state is accepted
with probability

$$
\min\bc{1, \frac{p(\tilde{\kappa_j}\mid \y,\rest)}
                {p(\kappa_j\mid \y,\rest)}}.
$$

The new state in the MCMC for $c_j$ is then $\frac{1}{1+\exp(-\kappa_j)}$.


## Full Conditional for $d$
The prior for $\rho = \log(d)$ is $\rho \sim \N(m_d, s^2_d)$.
The full conditional for $\rho$ is then:

\begin{align*}
p(\rho \mid \rest) 
\propto&~~ 
p(\rho)\times
\prod_{i=1}^{I} \prod_{j=1}^J p(\pi_{ij} \mid c_j, d)\\
%
\propto&~~ 
\exp\p{-\frac{(\rho-m_d)^2}{2s_d^2}}
\times \\
&~~ 
\prod_{i=1}^{I} \prod_{j=1}^J 
\piconst (\pi_{ij})^{\piconsta-1} (1-\pi_{ij})^{\piconstb-1} \\
\\
%
\propto&~~ 
\exp\p{-\frac{(\rho-m_d)^2}{2s_d^2}}
\Gamma(\exp(\rho))
\prod_{i=1}^{I} \prod_{j=1}^J 
\frac{(\pi_{ij})^{\piconsta}(1-\pi_{ij})^{\piconstb}}{\Gamma(\piconsta)\Gamma(\piconstb)}
%
\end{align*}

The parameter $d$ can be updated by updating $\rho$ and
then taking the inverse-logit the result. That is, we sample a candidate value
for the parameter $\tilde{\rho}$ from a Normal proposal centered at the
current iterate (say $\rho$) of the MCMC. The proposed state is accepted
with probability

$$
\min\bc{1, \frac{p(\tilde{\rho}\mid \y,\rest)}
                {p(\rho\mid \y,\rest)}}.
$$

The new state in the MCMC for $d$ is then $\exp(\rho)$.

## Sampling $K$

So far, we have treated the dimensions $K$ of the latent feature matrix $\Z$ as
fixed. This may be limiting as separate models may need to be fit for each
choice of $K$ (via cross-validation), which comes at a great computational
cost. Moreover, learning the number of latent features $K$ is the motivation
for using the IBP (a nonparametric distribution) as a prior for the latent
feature matrix. So we now introduce an algorithm based on MCMC for sampling
$K$. The idea is to iteratively

1. sample $(\bm\theta, K)$ jointly using a small "training set" to learn a prior for $\btheta$.
2. sample $(\bm\theta \mid K)$ based on the most recent $K$ using a large subset of the entire data (which we will call the "testing set").

The algorithm will be expounded upon below. 

### Sampling $(\bm\theta, K \mid \y)$ using Small Training Set to Learn Prior for $\btheta$

Let $\y^{TR}$ refer to a (predetermined) randomly selected subset of
observations of the entire data. We will call this the training set.  This set
should be small -- the number of rows in $\y^{TR}$ should be about 5% that of
the entire data $\y$. To ensure that the sample is representative of the data,
5% from each sample $i$ will be taken.  Let $\y^{TE}$ refer to the remaining
observations. That is, $\y = \y^{TE} \cup \y^{TR}$. We will call $\y^{TE}$ the
testing set.

Let the prior distribution for $K$ be $K \sim \Unif(1, K^{\max})$, where
$K^{\max}$ is some integer **sufficient large** (trial and error, start with
15?).  Also, let $p^\star(\bm\theta) = p(\bm\theta \mid \y^{TR}, K)$ be the
posterior distribution of $\bm\theta$ given the training set and $K$.
That is, we learn the prior distribution for $\btheta$ from a small training
set.

The joint posterior for $(\bm\theta, K)$ is then

\begin{align*}
p(\theta,K \mid \y^{TE}) &\propto p(K)p^\star(\bm\theta)
p(\y^{TE} \mid \bm\theta, K) \\
%%%
&\propto p(K)
p(\bm\theta \mid K, \y^{TR}) p(\y^{TE} \mid \bm\theta, K) \\
%%%
&\propto p(K)
p(\bm\theta\mid K) p(\y^{TR} \mid \bm\theta, K) p(\y^{TE} \mid \bm\theta, K) \\
&\propto p(K, \bm\theta)
p(\y^{TR} \mid \bm\theta, K) p(\y^{TE} \mid \bm\theta, K) \\
&\propto p(K, \bm\theta)
p(\y \mid \bm\theta, K) \\
\end{align*}

Note that this is the same as the posterior distribution of 
$(\bm\theta, K)$ given the entire data.

Simplifying the expression, we get

$$
p(\theta,K \mid \y^{TE})
\propto 
p(\bm\theta \mid K, \y^{TR}) p(\y^{TE} \mid \bm\theta, K).
$$

Note that $p(K)$ is missing from the expression as it is 
a constant with respect to $K$.

We can sample from the distribution using a Metropolis-Hastings
step. The proposal mechanism is as follows:

1. Propose $\tilde K \mid K \sim$
   $$
   \begin{cases}
   \Unif(K-a, K+a) &\text{ if } a+1 \le K \le K^{\max} -a \\
   \Unif(1, K+a) &\text{ if } K-a < 1 \\
   \Unif(K-a, K^{\max}) &\text{ if } K+a > K^{\max} \\
   \end{cases}
   $$
   That is, draw $\tilde K$ from a discrete uniform 
   distribution centered
   at the previous state $K$, within a neighbourhood of size
   $a$ which is a constant to be tuned, but is constrained
   such that $2a \le K^{\max}$.

   For clarity, the corresponding proposal densities for 
   $\tilde K$ are:

   $$
   \begin{cases}
   q_K(\tilde{K} \mid K) = (2a +1)^{-1} 
   & \text{ if } a+1 \le K \le K^{\max} -a\\
   q_K(\tilde{K} \mid K) = (K+a)^{-1}  
   & \text{ if } K-a < 1 \\
   q_K(\tilde{K} \mid K) = (K^{max} - K+a +1)^{-1} 
   &\text{ if } K+a > K^{\max} \\
   \end{cases}
   $$



2. Given $\tilde K$, we then propose 
   $\tilde{\bm\theta} \mid \tilde K$ with the proposal 
   distribution
   being the prior. To clarify, the prior here refers to the
   posterior distribution of $\bm\theta$ given the smaller
   training data. That is, 
   $q_\theta(\bm\theta) = p(\bm\theta \mid K, \y^{TR})$.
3. We accept the proposed draw $(\tilde K, \bm{\tilde\theta})$
   with probability $\min\bc{1, \Lambda}$ where 
   \begin{align*}
   \Lambda & = 
   \frac{
     p(\tilde K) p^\star(\tilde\btheta) p(\y^{TE} \mid \tilde\btheta, \tilde K)
   }{
     p(K) p^\star(\btheta) p(\y^{TE} \mid \btheta, K)
   }
   \times
   \frac{ %%% PROPOSAL
     q_K(K \mid \tilde K) q_\theta(\btheta \mid K)
   }{
     q_K(\tilde K \mid K) q_\theta(\tilde\btheta \mid \tilde K)
   }
   \\
   \\
   & = 
   \frac{
     p(\tilde K) p^\star(\tilde\btheta) p(\y^{TE} \mid \tilde\btheta, \tilde K)
   }{
     p(K) p^\star(\btheta) p(\y^{TE} \mid \btheta, K)
   }
   \times
   \frac{ %%% PROPOSAL
     q_K(K \mid \tilde K) p^\star(\btheta)
   }{
     q_K(\tilde K \mid K) p^\star(\tilde\btheta)
   }
   \\
   \\
   & = 
   \frac{
     p(\y^{TE} \mid \tilde\btheta, \tilde K)
     ~
     q_K(K \mid \tilde K)
   }{
     p(\y^{TE} \mid \btheta, K)
     ~
     q_K(\tilde K \mid K)
   }.
   \end{align*}

Note that sampling from $(\btheta \mid K, \y^{TR})$ can be done by sampling
from the full conditional of each parameter in $\btheta$. Note that
the steps for sampling from the full conditional of each parameter
in $\btheta$ given $K$ are already provided above. The only modification
needed is that a smaller subset of the data $\y^{TR}$ is used instead of the
entire data $\y$.

Since $K$ can be one of $\bc{1,...,K^{\max}}$. We need to keep $K^{\max}$
separate MCMC chains for $\btheta$ (one for each $K$). Each time a sample from
$\btheta \mid K, \y^{TR}$ is required for a particular $K$, only the 
Markov chain corresponding to that $K$ is updated. In terms of computation, 
note that in this way, the entire Markov chain need not be stored, but only
the most recent element in the chain (the most recent set of parameters
$\btheta$ for each $K$).

Finally, a small *burn-in* period may be necessary to obtain samples from 
$p^\star(\btheta) = p(\btheta \mid K, \y^{TR})$ for each $K$. That is, at the
**very start** of the algorithm, we should run $K$ MCMC chains (one for each
$K$) for to sample from $p(\btheta \mid K, \y^{TR})$ for some number of 
iterations (say 3000). This period acts as a burn-in to aid in collecting
better samples from the distribution.

### Sampling From $\btheta  \mid K, \y^{TE}$

Sampling from $\btheta \mid K, \y^{TE}$ can be done
by sampling from the full conditional of each parameter in $\btheta$ given
a large subset of the data $\y^{TE}$. Again, the steps for sampling from 
the full conditional of each parameter in $\btheta$ given $K$ is provided
previously. 
This time, the only modification needed is that the entire data $\y$ is used.


# Possible issues:

- Repeated columns allowed in $Z$ apriori
- Sampling $K$
    - using methods from the tumor purity project
        - split the data into two parts, training and testing
        - use the posterior of all parameters but K and 
        - use training data as a prior for testing data

# Alternative Methods:

- Variational Inference for $Z$ using stick-breaking construction [@doshi2009variational]
    - takes longer and has poorer performance for lower-dimension $Z$
    - faster and has better performance for higher-dimension $Z$


[comment]: <> (%
  All these are commented
  No strange spell checks in the commetns.
  $$\alpha$$
%)
