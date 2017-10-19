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
    - \newcommand{\TNpdf}[4]{\frac{\Npdf{#1}{#2}{{#3}^2}}{\Phi\p{\frac{#4-#2}{#3}}}}
    - \newcommand{\TNpdm}[4]{\frac{\Npdf{#1}{#2}{{#3}^2}}{1-\Phi\p{\frac{#4-#2}{#3}}}}
    - \newcommand{\TNpdfc}[4]{\frac{\Npdfc{#1}{#2}{{#3}^2}}{\Phi\p{\frac{#4-#2}{#3}}}}
    - \newcommand{\TNpdfcm}[4]{\frac{\Npdfc{#1}{#2}{{#3}^2}}{1-\Phi\p{\frac{#4-#2}{#3}}}}
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
        \TNpdm{y_{inj}}{\mus_{j#2}}{\sigma_i}{}
        }^{\Ind{e_{inj}=0#1}}
      }
    - \newcommand{\likezeroc}[2][]{
        \bc{
          \frac{
            \exp\bc{\frac{(y_{inj}-\mus_{j#2})^2}{2 \sigma^2_i}}
          }{
            1-\Phi\p{\frac{-\mus_{j#2}}{\sigma_i}}
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
            1-\Phi\p{ \frac{\log(2) - \psi_j}{\tau_j} }
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
            \Phi\p{ \frac{\log(2) - \psi_j}{\tau_j} }
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
            1-\Phi\p{ \frac{\log(2) - \psi_j}{\tau_j} }
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
            \Phi\p{ \frac{\log(2) -\psi_j}{\tau_j} }
          }
        }^{\Ind{
            \ifthenelse{\equal{#1}{}}{
              \mus_{j,#2}<\log(2),~z_{j#2}=0
            }{#1}
          }
        }
      }
    - \input{mh.tex}
#}}}1
---


# Sampling Distribution
<include file="params/sampling_dist.md">

## Marginal Sampling Distribution
<include file="params/marginal_sampling_dist.md">

# Priors
<include file="params/priors.md">

# Joint Posterior
<include file="params/joint_post.md">

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
<include file="params/mus.md">

## Full Conditional for $\bm\psi$
<include file="params/psi.md">

## Full Conditional for $\bm{\tau^2}$
<include file="params/tau2.md">

## Full Conditional for $\bm\pi$
<include file="params/pi.md">

## Full Conditional for $\sigma_i^2$
<include file="params/sig2.md">

## Full Conditional for $\v$
<include file="params/v.md">

## Full Conditional for $\h$
<include file="params/h.md">

## Full Conditional for $\bm\lambda$
<include file="params/lam.md">

## Full Conditional for $e_{inj}$
<include file="params/e.md">

## Full Conditional for $\w$
<include file="params/w.md">

## Full Conditional for $c_j$
<include file="params/c.md">

## Full Conditional for $d$
<include file="params/d.md">

## Sampling $K$
<include file="params/K.md">


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


# Ammendments

## Full Conditional for $\h$ (II)
<include file="params/h2.md">

## Full Conditional for $\v$ (II)
<include file="params/v2.md">

[comment]: <> (%
  All these are commented
  No strange spell checks in the commetns.
  $$\alpha$$
%)
