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
    - \titlegraphic{\includegraphics[scale=.3]{img/baskin-logo.jpg}}
    # OTHER defs:
    - \newcommand{\true}{{\mbox{\tiny TR}}}
    - \newcommand{\bZ}{\mbox{\boldmath $Z$}}
    - \newcommand{\bp}{\mbox{\boldmath $p$}}
    - \newcommand{\bq}{\mbox{\boldmath $q$}}
    - \newcommand{\bz}{\mbox{\boldmath $z$}}
    - \newcommand{\bw}{\mbox{\boldmath $w$}}
    - \newcommand{\bW}{\mbox{\boldmath $W$}}
    - \newcommand{\bI}{\mbox{\boldmath $I$}}
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

# CyTOF

# Review of Feature Allocation Models

# Project I: Bayesian Feature Allocation Model for Heterogeneous Cell Populations

# Project I: Simulation Study
\begin{figure}
  \begin{center}
\begin{tabular}{c}
\includegraphics[scale=.35]{../sampling/img/sim/Z_true_all.pdf}
  \end{tabular}
 \end{center}
 \vspace{-0.05in}
\caption{\tiny The transpose of $\bZ^\true$ with markers in columns and latent
phenotypes in rows. Black and white represents $z^\true_{jk}=1$ and 0,
respectively. The phenotypes and $\bw^\true_i$ are shown on the left and
right sides of each panel, respectively. The samples share the same $\bZ^\true$ and the phenotypes are arranged in order of
$w_{ik}^\true$ within each sample.}
\label{fig:sim-Z}
\end{figure}


# Project I: Simulation Study (FAM)
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

# Project I: Simulation Study (FAM)
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

# Project I: Simulation Study (FAM)
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
  \includegraphics[scale=.3]{../sampling/img/FlowSOM/YZ002_FlowSOM_SIM.png}\\
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
  \includegraphics[scale=.3]{../sampling/img/cb/YZ001.png}&
  \includegraphics[scale=.3]{../sampling/img/cb/YZ002.png}\\
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
  \includegraphics[scale=.3]{../sampling/img/FlowSOM/YZ001_FlowSOM_CB.png}&
  \includegraphics[scale=.3]{../sampling/img/FlowSOM/YZ002_FlowSOM_CB.png}\\
  {\small (a) Sample 1} & {\small(b) Sample 2} \\
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


# Project II: Repulsive Feature Allocation Model

# Project III: Feature Allocation Model with Regression for Abundances of Features


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
