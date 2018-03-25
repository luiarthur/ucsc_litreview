---
title: "Possible Model?"
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
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
    - \newcommand{\I}{\mathrm{\mathbf{I}}}
    #
    - \allowdisplaybreaks
    - \def\M{\mathcal{M}}
#}}}1
---

## Data and Input

- $\bm{y}_{in}$: a $J\times1$ vector, $i\in 1,...,I$, $n=1,...,N_i$
- $R$: a $J\times J$ correlation matrix (of the markers). May place a prior.

## Model 

\begin{align*}
\bm{y}_{in} \mid \bm{\mu}_{in}, \sigma^2_{in} &\sim \N(\bm{\mu}_{in}, \sigma^2_{in}\bm{I}_J) \\
\bm \mu_{in}, \sigma^2_{in} \mid F &\sim F \\
F \mid \alpha &\sim \text{DP}\p{\alpha, G_0=\N(\bm\mu_{in} \mid \bm{0}, \sigma^2_{in}R) \times \text{IG}(\sigma^2_{in} \mid a_\sigma, b_\sigma)} \\
\alpha &\sim \text{Gamma}(a_\alpha, b_\alpha)
~~~(\text{use auxiliary variable as in Escobar West, 1995})\\
\\
\tilde{\bm z}_{in} &:= \Ind{\bm\mu_{in} > 0}
~~~(\text{$J\times 1$ binary vector}) \\
\bm Z &:= \text{unique}\p{\bc{\tilde{\bm z}_{in}}}_{\forall(i,n)}
~~~ (\text{$J\times K$ binary feature matrix})\\
W_{ik} &:= \text{proportion of instances that column $Z_k$ is in} \bc{\tilde{\bm z}_{in}}_{n \in 1,...,N_i}
\end{align*}

## Notes on storage in MCMC

- At each iteration of MCMC, store only unique ($\bm\mu_{in}, \sigma^2_{in}$) pairs and the corresponding $(i,n)$ indices.
- $\bm Z$, $\bm W$, and the cluster labels can be recovered post-MCMC.


<!--
  These are comments
-->


[//]: # ( example image embedding
{{{1
\beginmyfig
\includegraphics[height=0.5\textwidth]{path/to/img/img.pdf}
\caption{some caption}
\label{fig:mylabel}
% reference by: \ref{fig:mylabel}
\endmyfig
)
[//]: # ( example image embedding
> ![some caption.\label{mylabel}](path/to/img/img.pdf){ height=70% }
)

[//]: # ( example two figs side-by-side
\begin{figure*}
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{img1.pdf}
    \caption{some caption}
    \label{fig:myLabel1}
  \end{minipage}\hfill
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{img2.pdf}
    \caption{some caption}
    \label{fig:myLabel2}
  \end{minipage}
\end{figure*}
1}}}
)


[//]: # (Footnotes:)


