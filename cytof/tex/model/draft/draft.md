---
title: CYTOF Model
#author: Draft
#date: " 4 March 2017"
author: "8 March 2017"
geometry: margin=1in
fontsize: 12pt

# Uncomment if using natbib:

bibliography: ../../bib/litreview.bib
bibliographystyle: plain 

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
    - \newcommand{\yin}{\bm{y}_{i,n}}
    - \newcommand{\muin}{\bm{\mu}_{i,n}}
    - \newcommand{\bmu}{\bm{\mu}}
    - \newcommand{\Z}{\mathbf{Z}}
    - \newcommand{\z}{\bm{z}}
    - \newcommand{\bzero}{\bm{0}}
    - \newcommand{\w}{\bm{w}}
    - \newcommand{\h}{\bm{h}}
    - \newcommand{\IBP}{\text{IBP}}
    - \newcommand{\Dir}{\text{Dirichlet}}
    - \newcommand{\IG}{\text{IG}}
    - \newcommand{\Be}{\text{Beta}}
    - \newcommand{\Ind}{\mathrm{I}}
    #
    - \allowdisplaybreaks
    - \def\M{\mathcal{M}}
---

[//]: # (To do:
  - Use "Bayesian Hierarchical Models for Protein Networks in Single-Cell Mass Cytometry" idea to subtract cut-off points?
)



1.  Notation

    (a) **Samples:** Let the total number of samples be $I$, and
        $i=1,...,I$. 

    (b) **Cells:** For each sample $i \in \bc{1,...,I}$, let the total
        number of cells in sample $i$ be $N_i$, and $n=1,...,N_i$.

    (c) **Markers:** Let $J$ be the total number of genetic markers of
        interest. (Expression levels are measured for the same set of
        surface markers in all cells of all samples.) Then, $j \in
        \bc{1,...,J}$ refers to one of the $J$ markers.

    (d) **Expression Levels:** Let $y_{i,n,j}$ be the expression level 
        of marker $j$ at cell $n$ in sample $i$ **after subtracting some
        cutoff expression level for marker $j$** so that 
        $y_{i,n,j} \in \mathbb{R}$. The subtraction is done to 
        remove background noise that may differ across samples.
        Furthermore, let $\yin = \bc{y_{i,n,1},..., y_{i,n,J}}$, 
        which is a vector of length $J$ containing the expression 
        levels of the $J$ markers for sample $i$ at cell $n$.


2.  Sampling Model

    Based on the notation above, we propose the following model:

$$
\yin \mid \muin, \sigma_i^2 \ind \N_J(\muin,\sigma_i^2 \I_J),
$$

> for $i=1,...i$ and $n=1,...,N_i$.

3.  Prior

    (a) **NK cell subpopulations**
        \par
        Suppose we have $K$ NK cell subpopulations.
        Subpopulation $k$ is characterized by a $J-$dim vector of zeros and ones,
        $\z_k=(z_{1, k}, \ldots, z_{J, k})$, $z_{j, k} \in \bc{0, 1}$.  Here $z_{j,
        k}=0$ means that surface marker $j$ is not expressed in subpopulation $k$
        and $z_{j, k}=1$ that marker $j$ is expressed. Collecting all columns into
        a matrix, we have $J \times K$ binary matrix $\Z$ whose columns are $\z_k$.
        We utilize a feature allocation model for $\Z$,
        $$
        \begin{split}
        \h_k \mid \Gamma &\iid \N_J(\bzero,\Gamma) \\
        v_l &\sim \Be(\alpha,1) \\
        b_k &:= \prod_{l=1}^k v_l \\
        z_{j,k} &= \Ind\p{\Phi(j_{j,k}\mid 0, \Gamma_{k,k} < b_k)} \\
        \end{split}
        $$
        From the last line of the equation, the probability that marker $j$ is
        expressed in subpopulation $k$ is $b_k$.  Note that the representation
        above is the stick-breaking representation of the Indian buffet process
        (IBP) and it is extended to model some associated markers through
        $\Gamma$ (@williamson2010dependent).  $\Gamma \neq \I_J$ may induce some
        associations between markers.  $\Gamma=\I_J$ reduces to the regular IBP
        assuming independence between markers.  The IBP assumes unknown $K$ so
        we learn $K$ from data.

    (b) **Mean Expression Levels for Subpopulations**
        \par
        Let $\bmu^\star_k$ be a
        $J-$dim mean-expression levels vector of surface markers for
        subpopulation $k$.  $\mu^\star_{j, k} >0$ if $z_{j,k} =1$ and
        $\mu^\star_{j, k} < 0$ if $z_{j,k} =0$.  Assume 
        $$
        \mu^\star_{j,k} \mid z_{j,k} \ind 
        \begin{cases}
          \N(0, \tau_j^2)I(\mu \geq 0) & \text{  if } z_{j,k}=1,\\ \N(0,
          \tau_j^2)I(\mu < 0) & \mbox{  if } z_{j,k}=0.\\ 
        \end{cases}
        $$

    (c) Composition of NK Cell Subpopulations in Samples
        \par
        We introduce $\w_i=(w_{i,1}, \ldots, w_{i,K})$, $0 < w_{i,k} <1$,
        $\sum_{k=1}^K w_{i,k}=1$,  given $\Z$.  Let a cell in sample $i$ belong
        to subpopulation $k$ with probability $w_{ik}$ (that is, clustering
        cells into latent subpopulations, but different probabilities across
        samples).  Let $\lambda_{i,n} \in \{1, \ldots, K\}$ a cluster
        membership of cell $n$ of sample $i$.  $\lambda_{i,n}=k$ means that
        cell $n$ of sample $i$ is in subpopulation $k$. Assume
        $$
        p(\lambda_{i,n} = k \mid \w_i) = w_{i,k}.
        $$  
        Note that $\w_i$ can be used to identify differences between samples.
        We further let $\bmu_{i,n} = \bmu^\star_k$ if $\lambda_{i,n}=k$. 


    (d) **Priors for** $\sigma^2_i$, $\tau^2_j$, $\w_i$
       \par
       $$
       \begin{split}
       \sigma_i^2 &\iid \IG(a_\sigma,b_\sigma) \\
       \tau_i^2 &\iid \IG(a_\tau,b_\tau) \\
       \w_i &\iid \Dir(1,...,1) \\
       \end{split}
       $$

4.  Additional Items

    (a) Computation: A sample has 20000 cells and we have multiple samples

    (b) Consider having a special cluster for cells not belonging to any
        subpopulation?

    (c) Consider allowing some $w_{i,k}=0$ (i.e. subpopulation $k$ does not appear
        in the sample $i$ at all)




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


