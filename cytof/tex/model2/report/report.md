---
#title: "Simulation Study for Cytof II"
#author: "Arthur Lui"
#date: "\\today"
geometry: margin=1in
fontsize: 12pt

# Uncomment if using natbib:

bibliography: litreview.bib
bibliographystyle: plain 

# This is how you use bibtex refs: @nameOfRef
# see: http://www.mdlerch.com/tutorial-for-pandoc-citations-markdown-to-latex.html

header-includes: 
#{{{1
    - \usepackage{bm}
    - \usepackage{bbm}
    - \usepackage{graphicx}
    - \pagestyle{plain}
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
    # This Project
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
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
    - \def\rest{\text{rest}}
    - \def\bang{\boldsymbol{\cdot}}
    - \def\h{\bm{h}}
    - \def\Z{\bm{Z}}
    - \def\Unif{\text{Unif}}

#}}}1
# Other header-includes:
include-before:
    - \title{Simulation Study for CYTOF Model II}
    - \author{Arthur Lui \\ UC Santa Cruz \\ \today}
    - \maketitle
---

[comment]: <> (%
  These are comments
%)

[comment]: <> (%
\abstract{
  PUT ABSTRACT HERE.
  \keywords{IBP, latent feature allocation model}
}
%)

# Introduction and Inferential Goal
<include file="includes/intro.md">

# Literature Review
<include file="includes/lit_review.md">

## Cytometry
<include file="includes/cytometry.md">

## Feature Allocation Models
<include file="includes/new_ibp.md">

# Probability Model
<include file="includes/model.md">

# Simulation Study
<include file="includes/sim_study.md">

## Data Generation
<include file="includes/data_gen.md">

## Simulation Study I
<include file="includes/sim_simple.md">

## Simulation Study II
<include file="includes/sim_complex.md">

## Simulation Study Conclusions
<include file="includes/sim_conclusion.md">

# Conclusion
<include file="includes/conclusion.md">

[//]: # (Footnotes:)

[comment]: <> (%
For figures and tables to stretch across two columns
use \begin{figure*} \end{figure*} and
\begin{table*}\end{table*}
Also, \begin{figure}[H] keeps figures close.
%)

