## Principal Components Analysis (PCA) =========================================
#' Used to reduce the number of variables by finding principal components of the
#' data, which are new and uncorrelated variables that can explain the most
#' variance in the original data.
#' 

### Correlation Matrix #########################################################
wm_df_prepped_cor <- cor(wm_df_prepped)

### Bartlett Test ##############################################################
#' The Bartlett test tests the null hypothesis that the correlation matrix is
#' equal to the identity matrix, meaning that the variables of a given dataset
#' are uncorrelated. If the resulting value is below .05, the null hypothesis is
#' rejected and it is concluded, that the variables are correlated.
#' reference: https://www.itl.nist.gov/div898/handbook/eda/section3/eda357.htm
psych::cortest.bartlett(wm_df_prepped_cor)
#' Way below .05.

### Kaiser-Mayer-Olkin Criterion (KMO) #########################################
#' The KMO measures the adequacy of a dataset for factor analysis.
#' It ranges from 0 to 1, where a higher value indicates higher suitability.
#' A value above .6 is generally considered to be the threshold.
#' However, some sources also consider .5 to be acceptable.
#' reference: https://www.empirical-methods.hslu.ch/entscheidbaum/interdependenzanalyse/reduktion-der-variablen/faktoranalyse/
psych::KMO(wm_df_prepped)$MSA
#' .559. I will consider this acceptable.

### PCA call ###################################################################
wm_df_pca <- 
  wm_df_prepped %>% 
  prcomp(scale. = T,
         center = T)
wm_df_pca %>% summary
#                    PC5    PC6     PC7     PC8     PC9     PC10    PC11   
# Standard dev.      1.2244 1.13610 1.02468 0.97962 0.94631 0.92042 0.88246
# Proportion of Var. 0.0517 0.04451 0.03621 0.03309 0.03088 0.02921 0.02685
# Cum. Proportion    0.6133 0.65785 0.69405 0.72714 0.75802 0.78723 0.81409
wm_df_pca %>% factoextra::fviz_eig(ncp = 15,
                                   addlabels = T)
# The elbow method would suggest a number of around 3 PCs

### Kaiser Criterion ###########################################################
#' The Kaiser Criterion states that factors with an eigenvalue above 1 are
#' considered important and should be retained. An eigenvalue above 1 means its
#' factor explains more variance than a single variable would.
factoextra::get_eig(wm_df_pca) %>% filter(eigenvalue > 1) %>% nrow
#' 7 factors have an eigenvalue above 1
factoextra::get_eig(wm_df_pca)[7,3]
#' Which would lead to a cumulative variance of 69.40507

### Horn's Method ##############################################################
#' Horn's Method is another method of determining the number of factors to keep
#' in a factor analysis (like PCA).
#' It does so by generating random data sets with equal size (columns and rows)
#' as the original data set and then performing a factor analysis on each of
#' them.
#' The retained number of factors are then compared. The idea is that if the
#' number of factors kept in the original data set is similar to the number of
#' factors kept in the random sets, the factors of the original data set are
#' considered not meaningful. If the number of factors of the original data set
#' is larger than the number of factors in the random sets, the factors in the
#' original data set are considered meaningful.
wm_df_prepped %>% paran::paran()
#' 6 components retained.

### Decision on number of PCs ##################################################
#' However, considering the cumulative variance I decide to keep 7 PCs.
n_PCs <- 7

### Plotting the contribution of original variable to each new PC ##############
plot_list = list()
for (i in 1:n_PCs) {
  p = factoextra::fviz_contrib(wm_df_pca, "var", axes = i)
  plot_list[[i]] = p
  rm(p)
}
#' Exporting as .png images
for (i in 1:n_PCs) {
  file_name = paste("pc_contrib_plot", i, ".png", sep="")
  png(file_name)
  print(plot_list[[i]])
  dev.off()
}

#' psych package has a function to illustrate the contribution of each original
#' variable to the created PCs in one plot
wm_df_prepped %>% psych::principal(nfactors = n_PCs) %>% psych::fa.diagram()

### Transformed Data Set based on PCA ##########################################
wm_df_transformed_pca <- as.data.frame(-wm_df_pca$x[,1:n_PCs])
