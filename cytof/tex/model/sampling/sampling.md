---
title: "DRAFT"
author: Arthur Lui
date: "29 April 2017"
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
    - \newcommand{\Bern}{\text{Bernoulli}}
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
    - \newcommand{\sign}[1]{\text{sign}\p{#1}}
    - \pagenumbering{gobble}
    - \newcommand{\logNpdf}[3]{\frac{1}{#1\sqrt{2\pi#3}}\exp\bc{-\frac{\p{\log(#1)-#2}^2}{2{#3}}}}
    - \newcommand{\Npdf}[3]{\frac{1}{\sqrt{2\pi{#3}}}\exp\bc{-\frac{\p{#1-#2}^2}{2#3}}}
    - \newcommand{\TNpdf}[3]{\frac{\Npdf{#1}{#2}{#3}}{\Phi\p{\frac{#1-#2}{#3}}}}
    - \newcommand{\rest}{\text{rest}}
    - \newcommand{\logit}{\text{logit}}
    - \newcommand{\piconsta}{\frac{\exp(\rho)}{1+\exp(-\kappa_j)}}
    - \newcommand{\piconstb}{\frac{\exp(\rho)}{1+\exp( \kappa_j)}}
    - \newcommand{\piconst}{\frac{\Gamma(\exp(\rho))}{\Gamma\p{\piconsta}\Gamma\p{\piconstb}}}
    - \newcommand{\likeone}[1][]{
        \bc{\delta_0(y_{inj})}^{\Ind{e_{inj}=1#1}}
      }
      #- \newcommand{\likezero}[2][]{
      #    \bc{
      #    \logNpdf{y_{inj}}{\mus_{j#2}}{\sigma_i^2}
      #    }^{\Ind{e_{inj}=0#1}}
      #  }
    - \newcommand{\likezero}[2][]{
        \bc{
        \TNpdf{y_{inj}}{\mus_{j#2}}{\sigma_i^2}
        }^{\Ind{e_{inj}=0#1}}
      }
    - \newcommand{\pone}[1]{
        p(y_{inj}\mid \mus_{j,#1}, \sigma_i^2, e_{inj}=1)
      }
    - \newcommand{\sumjn}{\sum_{j=1}^J\sum_{n=1}^{N_i}}
    - \newcommand{\pmugt}[1]{
        \bc{
          \frac{
            \Npdf{\mus_{j,#1}}{\psi_j}{\tau_j^2}
          }{
            1-\Phi\p{ \frac{(\mus_{j,#1}-\psi_j)-\log(2)}{\tau_j} }
          }
        }^{\Ind{\mus_{j,#1}>\log(2),~z_{j#1}=1}}
      }
    - \newcommand{\pmult}[1]{
        \bc{
          \frac{
            \Npdf{\mus_{j,#1}}{\psi_j}{\tau_j^2}
          }{
            \Phi\p{ \frac{(\mus_{j,#1}-\psi_j)-\log(2)}{\tau_j} }
          }
        }^{\Ind{\mus_{j,#1}<\log(2),~z_{j#1}=0}}
      }
    - \newcommand{\pmugtc}[1]{
        \bc{
          \frac{
            \exp\bc{-\frac{(\mus{j,#1}-\psi_j)^2}{2tau_j^2}}
          }{
            1-\Phi\p{ \frac{(\mus_{j,#1}-\psi_j)-\log(2)}{\tau_j} }
          }
        }^{\Ind{\mus_{j,#1}>\log(2),~z_{j#1}=1}}
      }
    - \newcommand{\pmultc}[1]{
        \bc{
          \frac{
            \exp\bc{-\frac{(\mus{j,#1}-\psi_j)^2}{2tau_j^2}}
          }{
            \Phi\p{ \frac{(\mus_{j,#1}-\psi_j)-\log(2)}{\tau_j} }
          }
        }^{\Ind{\mus_{j,#1}<\log(2),~z_{j#1}=0}}
      }
    - \input{mh.tex}
---


# Likelihood

$$
%\begin{cases}
%y_{inj} \mid \lambda_{i,n}=k, z_{jk}=1, \mus_{jk},\sigma_i^2 &\sim~ \LN(\mus_{jk}, \sigma_i^2)\\
%y_{inj} \mid \lambda_{i,n}=k, z_{jk}=0, \mus_{jk},\sigma_i^2 &\sim~ \pi_{ij}\delta_0(y_{inj}) + (1-\pi_{ij}) \LN(\mus_{jk}, \sigma_i^2) \\
%\end{cases}
\begin{array}{lcl}
y_{inj} \mid \mus_{j,\lin}, \sigma^2_i, e_{inj} &\sim&
\begin{cases}
\delta_0(y_{inj}) & \text{if } e_{inj}=1 \\
%\LN(\mus_{j,\lin}, \sigma^2_i), & \text{if } e_{inj}=0 \\
%\TN^+(\mus_{j,\lin}, \sigma^2_i), & \text{if } e_{inj}=0 \\
\TNpdf{y_{inj}}{\mus_{j,\lin}}{\sigma_i^2}, & \text{if } e_{inj}=0 \\
\end{cases}
\\
\\
e_{inj} \mid z_{j,\lin}=0,\pi_{ij} &\sim& \Bern(\pi_{ij}) \\
e_{inj} \mid z_{j,\lin}=1          &:=& 0 \\
\end{array}
$$

# Priors

- $\mus_{jk}$:
$$\begin{cases}
p(\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk}=1) ~~&=~~ 
\pmugt{k} \\
%
p(\mus_{jk} \mid \psi_j, \tau^2_j, z_{jk}=0) ~~&=~~ 
\pmult{k} \\
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
\mus_{j,\lambda_{i,n}} , \sigma^2_i, z_{j,\lambda_{i,n}}) } \\
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
it's full conditional distribution. Where this cannot be done conveniently, 
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
=&~
\frac{
\pi_{ij}\likeone
}{
\pi_{ij} \delta_0(y_{inj}) + 
(1-\pi_{ij}) p(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2, e_{inj}=1)
%\likezero{\mus_{j,\lin}}
} \\
\end{align*}

Similarly,
$$
p(e_{inj} = 0\mid z_{j,\lin}=0, \pi_{ij}, \rest)
=
\frac{
(1-\pi_{ij}) \pone{\lin}
}{
\pi_{ij} \delta_0(y_{inj}) + 
(1-\pi_{ij}) \pone{\lin}
}
$$


## Full Conditional for $\bm\mu^*$

\begin{align*}
p(\mus_{jk} \mid \y,\rest) \propto&~~ p(\mus_{jk}\mid z_{jk}, \psi_j, \tau_j^2) 
\times 
\prod_{i=1,n=1}^{I,N_i}
p(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2, e_{inj})\\
\\
\propto&~~ 
p(\mus_{jk}\mid \psi_j, \tau_j^2, z_{jk}=1)^{\Ind{\mus_{jk}>\log(2)}} \times
p(\mus_{jk}\mid \psi_j, \tau_j^2, z_{jk}=0)^{\Ind{\mus_{jk}<\log(2)}} \times
\\ &~~
\prod_{i=1}^I\prod_{n=1}^{N_i}
p(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2, e_{inj})\\
\\
\propto&~~
\pmugt{k}
\times \\
&~~
\pmult{k}
\times \\
&~~\prod_{i=1}^I\prod_{n=1}^{N_i}
\likeone[,\lin=k]
\times
\likezero[,\lin=k]{k}
\end{align*}

\mhSpiel{\mus_{jk}}

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
\pmugt{\lin}
\times \\
&\hspace{4em}
\pmult{\lin}
\end{split}
$$

\mhSpiel{\psi_j}


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
\pmugt{\lin}
\times \\
&\hspace{4em}
\pmult{\lin}
\end{split}
$$

\mhLogSpiel{{\tau_j^2}}{{\zeta_j}}


## Full Conditional for $\bm\pi$
The prior for $\pi_{ij} \mid c_j, d$ is $\Be^\star(c_j, d)$. So, the full 
conditional is

$$
\begin{split}
p(\pi_{ij}\mid \y,\rest) \propto&~~ p(\pi_{ij}) \times \\
&~~
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
%\propto&~~
%(\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)\times \\
%&
%(\sigma_i^2)^{-\p{JN_i - \p{\sumjn e_{inj}}}/2} \times \\
%& 
%\exp\bc{-\frac{\sumjn(1-e_{inj})\p{\log(y_{inj}-\mus_{j,\lin})}^2}{2\sigma_i^2}}\\
\end{align*}

\mhLogSpiel{{\sigma_i^2}}{{\xi_i}}



## Full Conditional for $\v$ (FIXME)

The prior distribution for $v_l$ are $v_l \mid \alpha \ind \Be(\alpha, 1)$, for 
$l = 1,...,K$. So, $p(v_l \mid \alpha) \propto v_l^{\alpha-1}$. Also, let
$v_0 = 1$ (deterministically). Then,

\begin{align*}
p(v_k \mid \y,\rest)
\propto&~
p(v_k \mid \alpha) 
\prod_{i=1}^I\prod_{n=1}^{N_i} \prod_{j=1}^J
p(y_{inj} \mid \mus_{j,\lin}, \sigma_i^2, e_{inj})^{\Ind{\lin\ge k}} \\
%
\propto&~
v_k^{\alpha-1}
\prod_{i=1}^I\prod_{n=1}^{N_i} \prod_{j=1}^J
\likeone[,~\lin \ge k]
\times \\
&\hspace{7em}
\likezero[,~\lin \ge k]{k}
\end{align*}

Note that, if $\mus_{jk}>0$ then $z_{jk}=1$ by definition, which in turn affects
$v_k$. This behavior is undesirable. So, we will jointly update $\mus_{jk}$ and
$v_k$. More accurately, we will jointly update $(\bm\mus_{k:K}, \phi_k)$,
where $\phi_k$ is the logit-transformation of the parameter $v_k$.
A metropolis update is required.  Let $Q_1$ be the proposal distribution.
The proposal mechanism will be as follows:

1. Given the current state $(\phi_k, \bm\mus_{k:K})$,
   sample a proposed state $\tilde\phi_k$ from $\N(\cdot \mid \phi_k, \Sigma)$ 
   for $\phi_k$, where $\Sigma$ is some positive real number to be tuned.
2. Compute the new $z_{jk}$ for $j = 1,...,J$.
3. If $z_{jk}$ is unchanged, then the proposed state for $\mus_{jk}$ is simply
   it's current state. Otherwise, the proposed state is 
   $\tilde{\mus_{jk}} \sim \N(\cdot \mid \psi_j, \tau_j^2, z_{jk})$ 
4. Compute the proposal density as 
   $$
   \begin{split}
   q_1((\tilde{\phi}_k, \tilde\mus_{j,k:K}) \mid (\phi_k, \mus_{j,k:K}))
   =
   \Npdf{\tilde\phi_k}{\phi_k}{\Sigma} \times  \\
   \end{split}
   $$



The proposed state $\widetilde{(v_k, \bm\mus_{k:K})}$ will be
accepted with probability 

$$
\min\bc{1, 
  \frac{
    p(\tilde{v_k}) p(\widetilde{\bm\mus_{k:K}}) p(\y \mid \bm{\mus, \sigma_2, e})
    \times
    q_1((v_k, \bm\mus_{k:K}) \mid (\tilde{v_k}, \widetilde{\bm\mus_{k:K}})) 
  }{
    p(v_k) p(\bm\mus_{k:K}) p(\y \mid \bm{\mus, \sigma_2, e})
    \times
    q_1( (\tilde{v_k}, \widetilde{\bm\mus_{k:K}}) \mid (v_k, \bm\mus_{k:K}) )
  }
}.
$$

## Full Conditional for $\h$ (FIXME)
The prior for $\h_k$ is $\h_k \sim \N_J(0, \Gamma)$.

$$
\begin{split}
p(\h_k \mid \y, -) 
\propto&~~ 
p(\h_k) 
\prod_{i=1}^I\prod_{n=1}^{N_i}\prod_{j=1}^J
p(y_{inj} \mid \mu_{jk}, \sigma_i^2, z_{jk}) ^{\Ind{\lin=k}}\\
%
\propto&~~ 
p(\h_k) 
\prod_{i=1}^I\prod_{n=1}^{N_i}\prod_{j=1}^J
p_1(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2) ^ {\Ind{\lin\ge k,~z_{jk}=1}} \times \\
&\hspace{7em}
p_0(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2) ^ {\Ind{\lin\ge k,~z_{jk}=0}}
\end{split}
$$

Similarly to $v_k$, we need to jointly update $(\h_k,\bm\mus_{k})$ so 
as to fully explore the sample space. This can be done with a metropolis
step with a 
multivariate Normal proposal distribution centered at the current
iterate $(\bm{\mus_{k}}, \h_k)$.
The proposed state $\widetilde{(\bm{\mus_{k}}, \h_k)}$ will be accepted
with probability 

$$
\min\bc{1, \frac{p(\tilde{\h_k}\mid \y,\rest)p(\tilde{\bm\mus_{k}}\mid \y, \rest)}
                {p(\h_k\mid \y,\rest)p(\bm\mus_{k}\mid \y, \rest)}}.
$$


## Full Conditional for $\bm\lambda$

The prior for $\lin$ is $p(\lin\mid \w_i) = w_{ik}$.

$$
\begin{split}
p(\lin=k\mid \y,\rest) \propto&~~ p(\lin=k) 
\prod_{i=1}^I\prod_{n=1}^{N_i}\prod_{j=1}^J
p(y_{inj}\mid \mu_{jk}^*, \sigma_i^2, e_{inj})^{\Ind{\lin=k}}\\
\propto&~~ 
w_{ik}
\prod_{i=1}^I\prod_{n=1}^{N_i}\prod_{j=1}^J
\likeone[,~\lin = k]
\times \\
&\hspace{7em}
\likezero[,~\lin=k]{k}
\end{split}
$$

Since $\lin$ has a discrete support, it's full conditional can be sampled from
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
\prod_{i=1}^{I} \prod_{j=1}^J p(\pi_{ij} \mid c_j, d)\\
%
\propto&~~ 
\exp\p{-\frac{\kappa_j^2}{2s_c^2}}
\times \\
&~~ 
\prod_{i=1}^{I} \prod_{j=1}^J 
\piconst (\pi_{ij})^{\piconsta-1} (1-\pi_{ij})^{\piconstb-1} \\
\\
%
\propto&~~ 
\exp\p{-\frac{\kappa_j^2}{2s_c^2}}
\prod_{i=1}^{I} \prod_{j=1}^J 
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


### Possible issues:

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
