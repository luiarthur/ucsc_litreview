---
title: CYTOF Model
author: Draft
date: " 4 March 2017"
geometry: margin=1in
fontsize: 12pt

# Uncomment if using natbib:

# bibliography: BIB.bib
# bibliographystyle: plain 

# This is how you use bibtex refs: @nameOfRef
# see: http://www.mdlerch.com/tutorial-for-pandoc-citations-markdown-to-latex.html

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
    - \newcommand{\yin}{\mathbf{y_{i,n}}}
    - \newcommand{\muik}{\bm{\mu_{i,k}}}
    - \newcommand{\Z}{\mathbf{Z}}
    - \newcommand{\IBP}{\text{IBP}}
    #
    - \allowdisplaybreaks
    - \def\M{\mathcal{M}}
---

[//]: # (To do:
  - Use "Bayesian Hierarchical Models for Protein Networks in Single-Cell Mass Cytometry" idea to subtract cut-off points?
)



# Notation

- Let the total number of samples be $I$. 
- For each sample $i \in \bc{1,...,I}$, let the total number of cells in sample $i$ be $N_i$.
- Let $J$ be the total number of genetic markers of interest. Then, $j \in \bc{1,...,J}$ refers to one of the $J$ markers.
- Finally, let $y_{i,n,j}$ be the expression level of marker $j$ at cell $n$ in
  sample $i$ **after subtracting some cutoff expression level for marker $j$**. 
  Furthermore, let $\yin = \bc{y_{i,n,1},..., y_{i,n,J}}$,
  which is a vector of length $J$ containing the expression levels of the $J$
  markers for sample $i$ at cell $n$.


# Model

Based on the notation above, we propose the following model:

$$
\begin{array}{rcl}
\yin \mid \lambda_{i,n}=k,\muik, \sigma_i^2 &\ind& \N_J^+(\muik,\sigma_i^2 \I_J), \text{ for } i=1,...,I, n = 1,...,N_i\\
\log(\muik) \mid \bm{\bar{\mu_i}}, \tau_i^2  &\ind& \N_J(\bm{\bar{\mu_i}}, \tau^2_i \I_J), \text{ for } i=1,...,I \\
\sigma_i &\ind& IG(a_{\sigma i},b_{\sigma i}), \text{ for } i=1,...,I \\
\tau_i &\ind& IG(a_{\tau i},b_{\tau i}), \text{ for } i=1,...,I \\
\\
p\p{\lambda_{i,n} = k \mid \Z} &\propto& w_{i,k}, \text{ where } \bm{w_t} = (w_{i,1},...,w_{i,k})\\
\Z &\sim& \IBP(\alpha) \\
\end{array}
$$

where 

- $\N_J^+(\cdot,.\cdot)$ denotes a positive-truncated multivariate Normal
distribution of dimension $J$,
- $\lambda_i,n \in \bc{1,...,K}$, where $K$ is some positive integer, represents the phenotype of sample $i$ in cell $n$.
- $\Z$ is a $J$ by $K$ random binary matrix where $K$ is random. Since each row in $\Z$ represents a marker, column $k$ of $\Z$ would represent a phenotype. 
- $X \sim IG(a,b)$ denotes that $X$ follows an inverse gamma distribution with pdf 
  $$f_X(x) = \ds\frac{b^a}{\Gamma(a)} x^{-a-1} e^{-b/x}$$


[//]: # ( example image embedding
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
)


[//]: # (Footnotes:)


