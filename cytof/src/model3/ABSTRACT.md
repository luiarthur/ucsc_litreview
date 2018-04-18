# Abstract


Advances in cytometry has led to a greater understanding of natural killer (NK)
cells and how their diversity impacts immunity against the development of
tumors and other viral diseases. NK-cell diversity within a (patient's) blood
sample can be quantified by the number of unique phenotypes present in the
cells of the sample. In the context of marker expression data obtained from a
cytometry at time of flight (CyTOF) analysis, a collection of expressed markers
defines a phenotype. A marker is considered to be expressed when the expression
level recorded by the cytometry device is beyond some threshold; and not
expressed otherwise. Moreover, when expression levels are extremely low, it
could be recorded as missing. Finally, phenotypes obtained by a simple boolean
analysis (to generate dichotomous structures) often yields a large number of
phenotypes when the underlying number of unique phenotypes could be much
smaller. We therefore propose modeling this latent structure using a latent
feature allocation model by using an Indian buffet process as a prior
distribution for the latent phenotypes. To account for missing values missing
not at random, we impute them using an informed prior missing mechanism.  As
the latent features of the latent feature allocation model can be susceptible
to label-switching problems, we will also propose some methods to summarize the
posterior distribution for the latent feature matrices.


