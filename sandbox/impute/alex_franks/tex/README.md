---
title: "Review of Literature on Missing Data Imputation"
author: Arthur Lui
date: "\\today"
geometry: margin=1in
fontsize: 12pt

header-includes:
#{{{1
    - \usepackage{bm}
    - \usepackage{bbm}
    - \def\fobs{f^{\text{obs}}}
    - \newcommand{\p}[1]{\left(#1\right)}
    - \newcommand{\bk}[1]{\left[#1\right]}
    - \newcommand{\bc}[1]{ \left\{#1\right\} }
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
#}}}1
---

This document is mostly based on Alexander Franks paper titled
[Non-standard conditionally specified models for non-ignorable missing data][1].
Of the papers he cites, many are works by Edoardo Airoldi and Donald Rubin. He
deals with missing-data models primarily where data are missing not at random.

In his paper, Alex discusses three basic model-representations for missing data.
The three representations are (1) selection factorization, (2) pattern-mixture 
factorization, and (3) Tukey's representation. He further describes an efficient
inferential strategy for models of the exponential family. He also notes 
that a fundamental challenge is that assumptions about the missing mechanism
are not typically testable from observed data. One way to address this is
through informed priors in the missing mechanism. This way, whatever uncertainty
remains in the prior is directly propagated to the posterior.

Throughout, $Y_i$ is the value of observation $i$. $R_i$ is an indicator such that
$R_i=1$ if $Y_i$ is observed. $Y = (Y_1, ..., Y_N)^T$, where $N$ is the total
number of observations. $\theta$ are parameters. Assuming $(Y_i,R_i)$ are i.i.d.,
their joint density is
$p(Y_i, R_i \mid \theta) = \prod_{i=1}^N f(Y_i, R_i \mid \theta)$.

The following is a brief summary of Alex's paper.

# Selection Factorization
As Alex points out, this representation (Rubin, 1974) factors the joint
distribution $(Y,R)$ as

$$
p(Y,R \mid \theta) = \prod_{i=1}^N f(Y_i\mid\theta_Y)f(R_i\mid Y_i,\theta_{R\mid Y})
$$

where $f(Y\mid\theta_Y)$ is the density of the complete data, and
$f(R\mid Y,\theta_{R\mid Y})$ is the missing mechanism.

This is currently what we are doing in our project, where $R$ is Bernoulli and
$\theta_{R\mid Y}$ is modeled through a logistic link function.

# Pattern-mixture Factorization
At the core of this representation (Rubin, 1977; Little, 1993; Little and
Rubin, 2014), separate models for the observed and unobserved data are used.
The complete data distribution is specified as a mixture of observed and
missing data components,

\begin{align*}
p(Y,R\mid\theta) &= \prod_{i=1}^N f(Y_i\mid R_i,\theta_{Y|R}) f(R_i\mid \theta_R)\\
&= \prod_{i=1}^N \prod_{r=0}^1 \bk{f(Y_i\mid R_i=r,\theta_{Y|R})
f(R_i=r\mid \theta_R)}^{\Ind{R_i=r}}.
\end{align*}

Note that here, $f(R\mid \theta_R)$ is a Bernoulli density with parameter
$\theta_R$ which does not depend on $Y$.


# Tukey's Representation
\begin{align*}
P(Y, R \mid \theta) &\propto \prod_{i=1}^N f(Y_i\mid R_i=1,\theta_{Y|R=1})
\cdot \frac{f(R_i \mid Y_i, \theta_{R|Y})}{f(R_i =1\mid Y_i, \theta_{R|Y})}
\end{align*}
with normalizing constant $\prod_{i=1}^N f(R_i =1\mid Y_i, \theta_{R|Y,
Y|R=1})$.  Alex notes that the advantage of this representation is that it only
involves the observed data density and the missingness mechanism, but not the 
complete data density.

# Notes

- Alex proposes efficient ways to sample from the full conditional of missing
values under the Tukey representation, where models are in the exponential
family or mixtures of exponential family. 

- Also, in section 4.1 (equation 11), he uses a missing mechanism very similar to the one we are currently using


---

**Link to Alex's paper**: https://arxiv.org/pdf/1603.06045.pdf

<!--
# Models

\begin{align*}
f(r_i = 1 \mid y_i, \beta) &= \text{logistic}(-\beta_0 - \beta_1 y_i) 
= (1 + \exp\{\beta_0 + \beta_1 y_i\})^{-1} \\
\fobs(y_i) &= \text{Normal}(0,1)
\end{align*}

## Model I
--!>

[1]: https://arxiv.org/pdf/1603.06045v1.pdf


