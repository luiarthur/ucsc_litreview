---
title: "Data Simulation for CYTOF"
author: Arthur Lui
date: "\\today"
geometry: margin=1in
fontsize: 12pt

# Uncomment if using natbib:

# bibliography: BIB.bib
# bibliographystyle: plain 

# This is how you use bibtex refs: @nameOfRef
# see: http://www.mdlerch.com/tutorial-for-pandoc-citations-markdown-to-latex.html

header-includes: 
#{{{1 Headers
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
#{{{2 Other headers:
    - \newcommand{\one}{\bm{1}}
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
#}}}2
---

[comment]: <> (%
  These are comments
%)

# Introduction
To explore the properties of the proposed CYTOF model, we simulate data
that resembles the data we are analyzing.

# Fixing the Dimensions of the Data and Latent Parameters
First, the dimensions $I$ (number of samples), $J$ (number of markers),
and $K$ (number of latent binary features). Then for each sample $I$,
the number of observations within the sample is fixed to be $N_i$.

# Fixing $\Z$
We first fix $\Z$ which is of dimension $(J\times K)$.
$\Z$ is a binary matrix where $z_{jk} = 1$ indicates that marker $j$ takes
on feature $k$; whereas $z_{jk}=0$ indicates that marker $j$ does not take
on feature $k$. Not all $2^{JK}$ possible binary matrices of size 
$J\times K$ are valid under the Indian buffet distribution, though.
For example, typically identical columns are usually considered a 
redundancy. A convenient yet meaningful choice of $\Z$ 
for a simulation study **when $J$ is a multiple of $K$** is:

$$
\I_K \otimes \one_q =
\begin{bmatrix}
\one_q   & \bzero_q & \cdots & \bzero_q \\
\bzero_q &   \one_q & \cdots & \bzero_q \\
\vdots   & \vdots   & \ddots &   \vdots \\
\bzero_q & \bzero_q & \cdots &  \one_q \\
\end{bmatrix}.
$$

where $A \otimes B$ is the Kronecker product of matrices $A$ and $B$,
$q$ is the $J / K$, and $\one_q$ and $\bzero_q$ are column vectors
of ones and zeros respectively. This matrix is attractive because it
implies four (clearly) distinct groups. Of course, $J$ need not
be a multiple of $K$, but is merely a convenient choice in a simulation
study. 

# Simulating $\psi_{j}$
Simulate $\psi_{j}$ from a Normal distribution with mean $2$ and
variance 1. That is, sample:

$$
\psi_j \iid \N(2, .5^2).
$$

This is chosen to reflect that from (real) observed data, the value
$y_{inj} = \log(\text{expression level} / \text{cutoff} + 1)$ has
a range of about (0,4). (Consequently, a suitable prior for $\psi_j$
may be $\N(2,1)$.)

# Simulating $\tau^2_j$
Simulate $\tau^2_{j}$ from an inverse gamma distribution
with (small) mean .1 and standard deviation .1. That is, sample:

$$
\tau^2_j \iid \IG(3, .2).
$$

Since this parameter governs the prior variance of $\mus_{jk}$ it 
is reasonable make it small to reflect that within a marker,
the variance should be smaller.

# Simulating $\mus_{jk}$
Next, sample the parameter $\mus_{jk}$ from a truncated Normal
distribution with different parameters depending on $z_{jk}$. That is,
sample:

$$
\mus_{jk} \ind \begin{cases}
\TN(\psi_j,\tau_j^2, \log(2),\infty), & \text{ if } z_{jk} = 1\\
\TN(\psi_j,\tau_j^2,-\infty,\log(2)), & \text{ if } z_{jk} = 0\\
\end{cases}
$$

# Fixing $\w_i$
The row vector $\w_i$ of dimension $K$ should be chosen thoughtfully
so that it sums to 1 and each element is between 0 and 1. For 
notational convenience, let $\bm W = \bk{\w_1^T ~ \w_2^T ~ \cdots ~
\w_I^T}^T$, which is an $I \times K$ matrix of positive probabilities. 

# Simulating $\lambda_{i,n}$
Assign $\lambda_{in}$ to be $k \in 1:K$ with probability $w_{ik}$.

# Simulating $\sigma^2_i$
Simulate $\sigma^2_{i}$ from an inverse gamma distribution
with mean 1 and standard deviation 1. That is, sample:

$$
\sigma^2_i \iid \IG(3, 2).
$$

This is to reflect the variation of real data. It is typical for 
$y_{in}$ to have variance between 0 and 1. 

# Simulating $\pi_{ij}$
$1-\pi_{ij}$ is the probability that $y_{inj}$ is expressed
when $z_{j,\lin} = 0$. To have a rich dataset, $1-\pi_{ij}$ should be
reasonably large. (i.e. $\pi_{ij}$ should be small). Hence, 
simulate $\pi_{ij}$ from a Beta distribution with parameters 1 and 9.
That is, sample:

$$
\pi_{ij} \iid \text{Beta}(.5, 1).
$$

This results in a beta distribution with mean of about .31 and standard 
deviation about .083. Figure \ref{hist} shows the distribution of 
the proportion of markers across all observations for all samples gathered
for patient 5 (in CYTOF data) that are 0 (i.e. not expressed). No
expressions occur in about 22% of the observations. For a $\Z$ matrix with
slightly more white 0's than 1's, it may be more appropriate to choose
a Beta distribution with a similar shape, but higher mean. Here,
for instance, I have chosen a Beta distribution with a mean of .3.

\beginmyfig
![bla](img/perczero.pdf){height=40%}
![bla](img/beta.pdf){height=40%}
\caption{Histogram of percentage of zeros in "patient 5" data (left).
Histogram of draws from Beta(.5, 1) distribution (right).}
\label{hist}
\endmyfig

# Simulating $y_{inj}$
Finally simulate $y_{inj}$ from a truncated Normal distribution
with parameters depending on $z_{jk}$. Specifically, sample:

$$
y_{inj} \sim
\begin{cases}
\TN(\mus_{j,\lin}, \sigma_i^2, 0, \infty) &\text { if } z_{j,\lin}=1
\\
\pi_{ij} \delta_0(\cdot) + 
(1-\pi_{ij})\TN(\mus_{j,\lin},\sigma_i, 0, \infty) &\text { if } z_{j,\lin}=0
\end{cases}
$$

