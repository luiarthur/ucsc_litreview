---
title: "Sampling Scheme for CYTOF Model3"
author: Arthur Lui
date: "\\today"
geometry: margin=1in
fontsize: 12pt
linestretch: 1.5

# Uncomment if using natbib:
bibliography: ../../bib/litreview.bib
bibliographystyle: plain 

# This is how you use bibtex refs: @nameOfRef
# see: http://www.mdlerch.com/tutorial-for-pandoc-citations-markdown-to-latex.html

header-includes: 
#{{{1
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
    - \def\logit{\text{logit}}
    - \def\Bern{\text{Bernoulli}}
    - \def\N{\text{Normal}}
    - \def\G{\text{Gamma}}
    - \def\IG{\text{Inverse-Gamma}}
    - \def\Dir{\text{Dirichlet}}
    - \def\Be{\text{Beta}}
    - \def\lin{\lambda_{in}}
    - \def\btheta{\bm{\theta}}
    - \def\y{\bm{y}}
    - \newcommand\m{\bm{m}}
    - \def\mus{\mu^*}
    - \def\sss{{\sigma^2}^*}
    - \input{includes/mhSpiel.tex}
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
    - \def\rest{\text{rest}}
    - \def\bang{\boldsymbol{\cdot}}
    - \def\h{\bm{h}}
    - \def\Z{\bm{Z}}
    - \def\Unif{\text{Unif}}
#}}}1
---


# Notation
<include file="includes/notation.md">

\newpage
# Sampling Model
<include file="includes/model.md">

# Priors
<include file="includes/priors.md">

# Sampling via MCMC
<include file="includes/mh.md">

# Full Conditionals

## Full Conditional for $\bm \beta$
<include file="includes/beta.md">

## Full Conditional for Missing $\bm \y$
<include file="includes/y_missing.md">

## Full Conditional for $\bm\mu^*$
<include file="includes/mus.md">

## Full Conditional for $\bm{{\sigma^2}}^*$
<include file="includes/sig2.md">

## Full Conditional for $s_i$
<include file="includes/si.md">

## Full Conditional for $\bm\gamma$
<include file="includes/gamma.md">

## Full Conditional for $\bm\eta$
<include file="includes/eta.md">

<!--
To speed up computation, 
- update v jointly using Langevin MC
- update H jointly using Langevin MC
-->
## Full Conditional for $\bm v$
<include file="includes/v.md">

## Full Conditional for $\alpha$
<include file="includes/alpha.md">

## Full Conditional for $\bm H$
<include file="includes/h.md">

## Full Conditional for $\bm \lambda$
<include file="includes/lam.md">

## Full Conditional for $\bm W$
<include file="includes/W.md">

## Posterior Estimate for $Z$, $W$, and $\lambda$
<include file="includes/post_est.md">

<!--
## Full Conditional for $K$
<include file="includes/K.md">
-->

<!-- comments -->

