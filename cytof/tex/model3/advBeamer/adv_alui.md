---
# COMMENT OUT IF NOT USING BIBLIOGRAPHY
bibliography: ../sampling/litreview.bib  
bibliographystyle: plain
# This is how you use bibtex refs: @nameOfRef
# see: http://www.mdlerch.com/tutorial-for-pandoc-citations-markdown-to-latex.html

header-includes:
#{{{1
    - \usepackage[T1]{fontenc}
    - \usepackage{amssymb,bm,mathtools,amsmath,bbm}
    - \usepackage{graphicx,caption,float}
    - \def\beginmyfig{\begin{figure}[H]\begin{center}}
    - \def\endmyfig{\end{center}\end{figure}}
    - \newcommand{\tbf}[1]{\textbf{#1}}
    # MATH
    - \newcommand{\iid}{\overset{iid}{\sim}}
    - \def\inv{^{\raisebox{.2ex}{$\scriptscriptstyle-1$}}}
    - \newcommand{\m}[1]{\mathbf{\bm{#1}}} # Serif bold math
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
    # Title:
    - \title[Bayesian FAM for CyTOF Data]{Bayesian Feature Allocation Models for Natural Killer Cell Repertoire Studies Using Mass Cytometry Data}
    - \author[A. Lui]{Arthur Lui \\ {\small Advisor$\colon$ Juhee Lee}}
    #- \institute{ AMS\\ UC Santa Cruz \footnote{UCSC is awesome}}
    #- \titlegraphic{\vspace{2.0em}\hspace{-6em}\includegraphics[scale=.3]{img/baskin-logo.jpg}}
    - \institute{Department of Applied Mathematics and Statistics\\ UC Santa Cruz}
    #- \titlegraphic{\includegraphics[scale=.3]{img/baskin-logo.jpg}}
    # OTHER defs:
    - \def\logit{\text{logit}}
    - \newcommand{\true}{{\mbox{\tiny TR}}}
    - \newcommand{\bZ}{\mbox{\boldmath $Z$}}
    - \newcommand{\bp}{\mbox{\boldmath $p$}}
    - \newcommand{\bq}{\mbox{\boldmath $q$}}
    - \newcommand{\bz}{\mbox{\boldmath $z$}}
    - \newcommand{\bw}{\mbox{\boldmath $w$}}
    - \newcommand{\bW}{\mbox{\boldmath $W$}}
    - \newcommand{\bI}{\mbox{\boldmath $I$}}
    - \newcommand{\ind}{\overset{ind}{\sim}}
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
    - \newcommand{\by}{\mbox{\boldmath $y$}}
    - \def\bmu{\bm{\mu}}
    - \def\bnu{\bm{\nu}}
    - \def\bomega{\bm{\omega}}
    - \def\bgam{\bm{\gamma}}
    - \def\bsig{\bm{\sigma}}
    - \def\blambda{\bm{\lambda}}
    - \def\bet{\bm{\eta}}
    - \def\lin{\lambda_{in}}
    - \def\h{\bm{h}}
    - \def\mus{\mu^\star}
    - \def\sss{{\sigma^2}^\star}
#}}}1
---

<!--Make Title page -->
<!--\date{\today}-->
\date{8 June 2018}
\titlepage

<!-- Outline:
- Motivating Example
- FAM
- Project I
    - Simulation Study
    - K sensitivity
    - FlowSOM
    - CB
- Project II
    - Rep-FAM
    - rep-FAM simulations study
- Project III
    - Plan
- Timeline
-->

<!-- one minute -->
# Introduction

- **Cytometry at time-of-flight (CyTOF)**
    \setlength\itemsep{1em}
    \begin{minipage}{\textwidth}
    \begin{columns}[T]
    \begin{column}{0.1\textwidth}
    \vspace{5em}
    \includegraphics[scale=0.5]{img/CyTOF_instrument.jpg}
    \end{column}
    \begin{column}{0.6\textwidth}
    \begin{itemize}
    \item
    commercialized in 2009
    \item 
    makes use of time-of-flight mass spectrometry to accelerate, separate, and
    identify ions by mass
    \item
    enables detection of many parameters (biological, phenotypic, or functional
    markers) in less time and at a higher resolution \citep{cheung2011screening}
    \item 
    led to greater understanding of natural killer (NK) cells
    \end{itemize}
    \end{column}
    \end{columns}
    \end{minipage}

- **Natural Killer cells** play a critical role in cancer immune
  surveillance and are the first line of defense against viruses and
  transformed tumor cells. 


<!-- one minute -->
# CyTOF Data
<!--latex table generated in R 3.4.4 by xtable 1.8-2 package
Mon Jun  4 10:45:42 2018-->
<!--transformed data
\begin{tabular}{rrrrrrrr}
  \hline
 & 2B4 & 2DL1 & 2DL3 & 2DS4 & 3DL1 & CCR7 & CD158B \\
  \hline
1 & 1.83 & NA & 0.82 & -1.03 & 1.67 & NA & 1.03 \\
  2 & 2.37 & -2.63 & -2.73 & -2.00 & 2.44 & -1.39 & -2.70 \\
  3 & 0.56 & NA & NA & NA & NA & -0.08 & NA \\
   \hline
\end{tabular}
-->
<!-- original data, first three rows, first seven columns -->
\begin{table}
\begin{tabular}{r|rrrrrrr}
  \hline
  & 2B4 & 2DL1 & 2DL3 & 2DS4 & 3DL1 & CCR7 & $\cdots$ \\
  \hline
  1 & 47.60 & 0.00 & 30.90 & 1.35 & 82.49 & 0.00 & $\cdots$ \\
  2 & 81.84 & 0.44 & 0.88 & 0.51 & 176.99 & 2.38 & $\cdots$ \\
  3 & 13.33 & 0.00 & 0.00 & 0.00 & 0.00 & 8.81   & $\cdots$ \\
  4 & 23.64 & 3.37 & 43.39 & 0.27 & 0.73 & 0.00  & $\cdots$ \\
  5 & 156.19 & 0.00 & 9.04 & 0.00 & 0.00 & 11.43 & $\cdots$ \\
  6 & 273.86 & 0.00 & 9.71 & 2.41 & 0.84 & 0.52  & $\cdots$ \\
  $\vdots$ & $\vdots$& $\vdots$& $\vdots$& $\vdots$& $\vdots$& $\vdots$& \\
  \hline
  Cutoff & 7.62 & 6.07 & 13.60 & 3.79 & 15.50 & 9.52 & $\cdots$\\
  \hline
\end{tabular}
\caption{Cord-blood sample marker expression levels for 6 of 32 NK-cell markers
(columns), and 6 of 41474 cells (rows). Last row contains cutoff values
returned by CyTOF instrument.}
\end{table}

- Data missing not at random
    - Some markers contain up to 85% missing values
- Expression level range for each marker varies greatly

# CyTOF Data
\begin{table}
\begin{tabular}{r|rrrrrrr}
  \hline
  & 2B4 & 2DL1 & 2DL3 & 2DS4 & 3DL1 & CCR7 & $\cdots$ \\
  \hline
  1 & 1 & 0 & 1 & 0 & 1 & 0 & $\cdots$ \\
  2 & 1 & 0 & 0 & 0 & 1 & 0 & $\cdots$ \\
  3 & 1 & 0 & 0 & 0 & 0 & 0 & $\cdots$ \\
  4 & 1 & 0 & 1 & 0 & 0 & 0 & $\cdots$ \\
  5 & 1 & 0 & 0 & 0 & 0 & 1 & $\cdots$ \\
  6 & 1 & 0 & 0 & 0 & 0 & 0  & $\cdots$ \\
  $\vdots$ & $\vdots$& $\vdots$& $\vdots$& $\vdots$& $\vdots$& $\vdots$& \\
  \hline
  Cutoff & 7.62 & 6.07 & 13.60 & 3.79 & 15.50 & 9.52 & $\cdots$\\
  \hline
\end{tabular}
\caption{Cell phenotypes (rows)}
\end{table}

- Obtaining cell phenotypes using overly-simplistic methods may yield unreasonably high number of sub-populations.

# Existing Methods

- Most existing methods use traditional clustering methods (K-means, hierarchical clustering, density-based clustering, etc.)
\setlength\itemsep{1em}
- Existing methods do not directly model latent phenotypes
- Existing methods do not quantify model uncertainty

<!-- 30 seconds -->
# Proposed Projects


- **Project I**: Bayesian Feature Allocation Model for Heterogeneous Cell Populations
    \setlength\itemsep{1em}
- **Project II**: Repulsive Feature Allocation Model
- **Project III**: Feature Allocation Model with Regression for Abundances of Features in Longitudinal Data


<!-- 15 minutes -->
# Project I: Bayesian Feature Allocation Model for Heterogeneous Cell Populations
## Notation
- $I$: Number of samples
- $J$: Number of markers
- $N_i$: Number of observations in sample $i$
- $\tilde{y}_{inj}$: Raw expression levels for observation $n$ in sample $i$ for marker $j$. $(\tilde y_{inj} \ge 0)$
- $c_{ij}$: Cutoff for marker $j$, sample $i$
- $y_{inj}$: Transformed expression levels for observation $n$, sample $i$, marker $j$
$$
y_{inj}=\log\p{\frac{\tilde{y}_{inj}}{c_{ij}}} \in \mathbb{R}.
$$
    - $(y_{inj} \gg 0)$ likely corresponds to expression
    - $(y_{inj} \ll 0)$ likely corresponds to non-expression

# Project I: Bayesian Feature Allocation Model for Heterogeneous Cell Populations
- $\lambda_{in} \in \bc{1,...,K}$: The latent phenotype of observation $n$, sample $i$
    - $K$ is a sufficiently large constant
- $\bZ$: $(J \times K)$ binary matrix defining the latent phenotypes.
    - if $Z_{jk} = 1$, then marker $j$ is expressed in phenotype $k$
    - if $Z_{jk} = 0$, then marker $j$ is not expressed in phenotype $k$


# Project I: Sampling Distribution
\begin{align*}
y_{inj} \mid \bet_{ij}, \bmu^\star, \bsig^{2 \star}_{i} \ind
\begin{cases}
  \sum_{\ell=1}^{L^0} \eta^0_{ij\ell}~ \text{Normal}(\mu^\star_{0\ell}, \sigma^{2 \star}_{0i\ell}), &\mbox{if $z_{j,\lambda_{in}}=0$},\\
  \sum_{\ell=1}^{L^1} \eta^1_{ij\ell}~ \text{Normal}(\mu^\star_{1\ell}, \sigma^{2 \star}_{1i\ell}), &\mbox{if $z_{j,\lambda_{in}}=1$}.\\
\end{cases} \label{eq:y-mix}
\end{align*}

- Fixed number of mixture components $L^0$ and $L^1$
- Mixture weights $\bet^0_{ij}$ and $\bet^1_{ij}$ where
$\sum_{\ell=1}^{L^0} \eta^0_{ij\ell}=\sum_{\ell=1}^{L^1}\eta^1_{ij\ell}=1$,
and $\eta^0_{ij\ell}, \eta^1_{ij\ell} > 0$
- For computational convenience, we introduce mixture component indicators
  $\gamma_{inj}$ for $y_{inj}$ so that 
  $$ P(\gamma_{inj} = \ell \mid \lin=k)=\eta^{z_{jk}}_{ij\ell}, \mbox{ where }~ \ell \in \{1,\ldots, L^{z_{jk}}\}.$$
  Then,
  $$ 
    y_{inj} \mid \mu_{inj}, \sigma^2_{inj}, \lin=k, \gamma_{inj}=\ell  \ind
    \text{Normal}(\mu_{inj}, \sigma^2_{inj}),
  $$
  where $\mu_{inj}=\mu^\star_{z_{jk},\ell}$ and 
  $\sigma^2_{inj}={\sigma^{2}}^\star_{z_{jk}i\ell}$.


# Project I: Missing Mechanism
\begin{align*}
  m_{inj} \mid p_{inj} &\ind \text{Bernoulli}(p_{inj}) \\
  \logit(p_{inj}) &= \begin{cases}
  \beta_{0i} - \beta_{1i}(y_{inj}-c_0)^2, & \text{if } y_{inj} < c_0\nonumber, \\
  \beta_{0i} - \beta_{1i}c_1\p{y_{inj}-c_0}^{1/2}, & \text{otherwise}, \nonumber \\
  \end{cases} 
\end{align*}
where $m_{inj}=1$ if $y_{inj}$ is missing, and 0 otherwise.
\beginmyfig
\includegraphics[scale=.20]{../sampling/img/prob_miss_example.pdf}
\caption{Example missing mechanism}
\endmyfig

# Project I: Priors
## Latent Phenotypes
\begin{eqnarray*}
  v_k \mid \alpha &\iid& \text{Beta}(\alpha/K, 1),~ k=1, \ldots, K \\
  \alpha &\sim& \text{Gamma}(a_\alpha, b_\alpha) \\
  \h_k &\iid& \text{Normal}_J(\mathbf{0}, \Gamma) \\ 
  z_{jk} \mid h_{jk}, v_k &=& \mathbb{I}\bc{ \Phi(h_{jk} \mid 0,
  \Gamma_{jj}) < v_k }
\end{eqnarray*}

## Phenotype Abundance
Let $w_{ik}$ denote an abundance level of phenotype $k$ in sample $i$.
Let $\bw_i=(w_{i1}, \ldots, w_{iK})$. Then, $\bw_{i} \mid K \iid
\text{Dirichlet}_K(d/K)$.

## Latent Cell Phenotype Indicators
$$p(\lin=k \mid \bm \bw_i) = w_{ik}$$

# Project I: Priors
\begin{align*}
\mus_{0\ell} \mid \psi_0, \tau^2_0 &\iid \text{Normal}_-(\psi_0, \tau^2_0), ~~~ \ell \in \bc{1,...,L^0} \\
\mus_{1\ell} \mid \psi_1, \tau^2_1 &\iid \text{Normal}_+(\psi_1, \tau^2_1), ~~~ \ell \in \bc{1,...,L^1} \\
\sigma^2_{0i\ell} \mid s_i &\ind \text{Inverse-Gamma}(a_\sigma, s_i), ~~~ \ell \in \bc{1,...,L^0} \\
\sigma^2_{1i\ell} \mid s_i &\ind \text{Inverse-Gamma}(a_\sigma, s_i), ~~~ \ell \in \bc{1,...,L^1}  \\
s_i &\iid \text{Gamma}(a_s, b_s) \\
\bm\eta^0_{ij} &\iid \text{Dirichlet}_{L^0}(a_{\eta^0}/L^0), ~~~ i \in \bc{1,...,I}, j \in \bc{1,...,J} \\
\bm\eta^1_{ij} &\iid \text{Dirichlet}_{L^1}(a_{\eta^1}/L^1), ~~~ i \in \bc{1,...,I}, j \in \bc{1,...,J} \\
\beta_{0i} &\iid \text{Normal}_-(m_{\beta_0}, s^2_{\beta_0}), ~~~ i \in \bc{1,...,I} \\
\beta_{1i} &\iid \text{Normal}_+(m_{\beta_1}, s^2_{\beta_1}), ~~~ i \in \bc{1,...,I} \\
\end{align*}


# Project I: Simulation Study
\begin{figure}
\begin{center}
\begin{tabular}{c}
\includegraphics[scale=.35]{../sampling/img/sim/Z_true_all.pdf}
\end{tabular}
\end{center}
\vspace{-0.05in} \caption{\tiny The transpose of $\bZ^\true$ with markers in
columns and latent phenotypes in rows. Black and white represents
$z^\true_{jk}=1$ and 0, respectively. The phenotypes and $\bw^\true_i$ are
shown on the left and right sides of each panel, respectively. The samples
share the same $\bZ^\true$ and the phenotypes are arranged in order of
$w_{ik}^\true$ within each sample.}
\end{figure}


# Project I: Simulation Study
\begin{figure}
\begin{center}
\begin{tabular}{c}
\includegraphics[scale=.35]{../sampling/img/sim/Y001.png}
\end{tabular}
\end{center}
\vspace{-0.05in} \caption{Simulated data for one sample}
\end{figure}


# Project I: Simulation Results (FAM)
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/sim/YZ001.png}&
  \includegraphics[scale=.3]{../sampling/img/sim/Z1_true.pdf}\\
  {\small (a) Sample 1} & {\small(b) Z true} \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{FAM Simulation Study}
\label{fig:sim-post-Z}
\end{figure}

# Project I: Simulation Results (FAM)
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/sim/YZ002.png}&
  \includegraphics[scale=.3]{../sampling/img/sim/Z2_true.pdf}\\
  {\small (a) Sample 2} & {\small(b) Z true} \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{FAM Simulation Study}
\label{fig:sim-post-Z}
\end{figure}

# Project I: Simulation Results (FAM)
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/sim/YZ003.png}&
  \includegraphics[scale=.3]{../sampling/img/sim/Z3_true.pdf}\\
  {\small (a) Sample 3} & {\small(b) Z true} \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{FAM Simulation Study}
\label{fig:sim-post-Z}
\end{figure}



# Project I: Simulation Study (FlowSOM)
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/FlowSOM/YZ001_FlowSOM_SIM.png}&
  \includegraphics[scale=.3]{../sampling/img/sim/Z1_true.pdf}\\
  {\small (a) Sample 1} & {\small(b) Z true} \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{FlowSOM Simulation Study}
\label{fig:sim-post-Z}
\end{figure}

# Project I: Simulation Study (FlowSOM)
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/FlowSOM/YZ002_FlowSOM_SIM.png}&
  \includegraphics[scale=.3]{../sampling/img/sim/Z2_true.pdf}\\
  {\small (a) Sample 2} & {\small(b) Z true} \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{FlowSOM Simulation Study}
\label{fig:sim-post-Z}
\end{figure}

# Project I: Simulation Study (FlowSOM)
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/FlowSOM/YZ003_FlowSOM_SIM.png}&
  \includegraphics[scale=.3]{../sampling/img/sim/Z3_true.pdf}\\
  {\small (a) Sample 3} & {\small(b) Z true} \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{FlowSOM Simulation Study}
\label{fig:sim-post-Z}
\end{figure}


# Project I: CB Study (FAM)
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/cb/YZ001.png}&
  \includegraphics[scale=.3]{../sampling/img/cb/YZ002.png}\\
  {\small (a) Sample 1} & {\small(b) Sample 2} \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{\small[FlowSOM Simulation Study]}
\label{fig:sim-post-Z}
\end{figure}

# Project I: CB Study (FAM)
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/cb/YZ003.png} & \\
  {\small Sample 3} &  \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{\small[FlowSOM Simulation Study]}
\label{fig:sim-post-Z}
\end{figure}



# Project I: CB Study (FlowSOM)
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/FlowSOM/YZ001_FlowSOM_CB.png}&
  \includegraphics[scale=.3]{../sampling/img/FlowSOM/YZ002_FlowSOM_CB.png}\\
  {\small (a) Sample 1} & {\small(b) Sample 2} \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{\small[FlowSOM Simulation Study]}
\label{fig:sim-post-Z}
\end{figure}

# Project I: CB Study (FlowSOM)
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/FlowSOM/YZ003_FlowSOM_CB.png}\\
  {\small Sample 1} &  \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{\small[FlowSOM Simulation Study]}
\label{fig:sim-post-Z}
\end{figure}


# R Package
```R
# R code for installing cytof3

library(devtools)
repo = 'luiarthur/ucsc_litreview'
subdir = 'cytof/src/model3/cytof3'
install_github(repo, subdir=subdir)
```


<!-- 10 minutes -->
# Project II: Repulsive Feature Allocation Model
Include outline

# Project II: Simulation Study


<!-- 2 minutes -->
# Project III: Feature Allocation Model with Regression for Abundances of Features
Include outline


<!-- 10 seconds -->
# Timeline
\Large
\begin{table}[H]
  \begin{center}
    \begin{tabular}{{| l | l |}}
    \hline Project & Academic Quarter \\
    \hline
    Project 1  & Fall 17 - Fall 18  \\
    Project 2  & Fall 18 - Spring 19  \\
    Project 3  & Winter 19 - Fall 19  \\
    Thesis     & Fall 19 -   Winter 20  \\
    \hline
  \end{tabular}
  \end{center}
\end{table}



<!-- {{{2 Examples 
# Inserting images
\vspace{-1em}
\begin{figure}
  \begin{center}
  \begin{tabular}{cc}
  \includegraphics[scale=.3]{../sampling/img/sim/YZ001.png}&
  \includegraphics[scale=.3]{../sampling/img/sim/YZ002.png}\\
  {\small (a) Sample 1} & {\small(b) Sample 2} \\
  \end{tabular}
  \end{center}
  \vspace{-0.05in}
  \caption{\small[Simulation]}
\label{fig:sim-post-Z}
\end{figure}


# Citations
I just cited [@griffiths2011indian].
And now I'm citing @williamson2010dependent.
Citation Teh [-@teh2007stick].

# List
- item 1
- item 2
    1. Apple
    2. Orange
        1. Cat
        2. Dog
}}}2 -->
