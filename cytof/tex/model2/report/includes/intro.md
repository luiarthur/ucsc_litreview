Advances in cytometry has led to more research and greater understanding of
natural killer (NK) cells and how their diversity impacts immunity against the
development of tumors and other viral diseases.  The main inferential goal of
this project is to identify the NK cell phenotypes (or cell-types) in various
samples as a set of subpopulations of the set of some provided surface markers.
The NK cell-types are latent, and for $J$ markers $2^J$ different cell-types
can be considered. This provides a computational challenge when the number of
markers is even moderately large.  Thirty-two markers are included in this
analysis, and naively enumerating all possible markers is not feasible. We
therefore, use a latent feature allocation model to learn the latent structure
of predominant cell-types. Latent feature models have been successfully applied
to various problems and will be reviewed in section 2.2.

<!-- TODO (2)
I have the following suggestion for the Introduction section. I think you
already have all needed components in your sections 1 & 2, but reorganizing
the contents and having one Introduction section would make the paper
better. Please consider reorganizing as follows;
1• Include some scientific backgrounds on the study of NK cell.
NK cells? Why do researchers study NK cell populations?
What are
• Describe our inferential goals.
• How it was studied before (previous technology)? How the new cytometry
technology is better. This may pose some statistical challenges.
Discuss them.
• Existing statistical methods for cytometry data. What is missing in
the existing statistical methods? Limitations of the existing methods?
• We then introduce our approach in words. How ours is different from
the existing? How ours achieves our inferential goals? How ours may
be better than the existing ones?
• Whenever it is possible, please include references.
-->

<!-- TODO (1)
How do we define NK cell phenotypes? Why do we study NK cell phenotypes?
How do we get 2 J different cell types (I think this depends on our definition
of cell types)? Please explain how you define a cell type. This may be
related to why we use IBP to model cell types as you described the below.
-->
