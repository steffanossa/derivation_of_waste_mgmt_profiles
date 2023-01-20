## Factor Analysis (FA) ========================================================
#' Like the PCA a factor analysis can be used to reduce the dimensions of a data
#' set.
#' However, while the PCA creates uncorrelated variables the FA identifies
#' underlying latent factors that explain the relationships among the original
#' variables in the data set.
#' The factors the FA puts out might be correlated, so a rotation can be used in
#' make these factors as uncorrelated as possible.

#' Vector containing all rotation methods
rot_meth <- c("varimax", "quartimax", "equamax", "oblimin", "oblimax", "promax")
#' For-loop iterating over each rotation method giving out the results
for (rm in rot_meth) {
  invisible(
    readline(
      prompt=paste0("[enter] to show next rotation result")))
  cat("Factor Analysis results. Rotation method: ", rm)
  wm_df_prepped %>% factanal(factors = n_PCs,
                             rotation = rm,
                             lower = 0.01) %>% 
    print
}
#' I don't know what happened to oblimax.
#' Several rotation methods resulted in a cumulative variance of .583
#' (varimax, quartimax, equamax). I consider this too low and am going to use
#' PCA instead.
