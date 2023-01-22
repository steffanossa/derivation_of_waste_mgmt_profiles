Derivation of Waste Management Profiles
================
steffanossa
last-modified

## Todos:

- [ ] references: \~bartlett test\~, <sub>kmo</sub>, pca, fa
- [ ] clustering: diana, mona, agnes, k-means
- [ ] profiling
- [ ] output code

## Context

Although only about 15% of all waste within the EU is generated as
municipal waste[^1], the absolute figures pose a major problem for
municipalities, waste management companies and the environment. 225.7
million tonnes of municipal waste were collected in the EU in 2020, of
which only 68 million tonnes were directly recycled, with the remainder
going into long-term landfill or being incinerated for energy
generation. In view of the climate-damaging landfill gases produced
during storage or CO2 emissions during incineration, combined with the
problem of the large amount of space required, the EU’s goal is to
constantly optimise its waste management. This is intended to promote
the production of less waste, a stronger circular economy and the
economic efficiency of waste management. In the context of this
optimisation, we want to work out a status quo of municipal waste
management in Italian municipalities, on which subsequent optimisation
projects can build. For this purpose, we base our work on a data set on
the waste management of a total of 4341 Italian municipalities. With the
help of these data, we are to draw up profiles of the municipalities,
which we can cluster them with regard to their descriptive
characteristics, in particular the key figures of waste management, but
also geographical and economic factors.

## Exploratory Data Analysis

Get an overview of the data set.

``` r
wm_df <- load2("data/waste_management.RData")
skimr::skim(wm_df)
```

|                                                  |       |
|:-------------------------------------------------|:------|
| Name                                             | wm_df |
| Number of rows                                   | 4341  |
| Number of columns                                | 36    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |       |
| Column type frequency:                           |       |
| character                                        | 5     |
| numeric                                          | 31    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |       |
| Group variables                                  | None  |

Data summary

**Variable type: character**

| skim_variable     | n_missing | complete_rate | min | max | empty | n_unique | whitespace |
|:------------------|----------:|--------------:|----:|----:|------:|---------:|-----------:|
| Region            |         0 |             1 |   5 |  21 |     0 |       20 |          0 |
| Provinz           |         0 |             1 |   4 |  21 |     0 |      102 |          0 |
| Gemeinde          |         6 |             1 |   2 |  60 |     0 |     4333 |          0 |
| Gebuehrenregelung |         0 |             1 |   4 |   8 |     0 |        2 |          0 |
| Region_PAYT       |         0 |             1 |   2 |   4 |     0 |        2 |          0 |

**Variable type: numeric**

| skim_variable          | n_missing | complete_rate |     mean |       sd |      p0 |      p25 |      p50 |      p75 |       p100 | hist  |
|:-----------------------|----------:|--------------:|---------:|---------:|--------:|---------:|---------:|---------:|-----------:|:------|
| ID                     |         0 |          1.00 | 47469.93 | 30089.80 | 1272.00 | 18135.00 | 42015.00 | 70049.00 |  111107.00 | ▇▃▅▃▃ |
| Flaeche                |         6 |          1.00 |    41.00 |    56.78 |    0.12 |    10.85 |    22.73 |    47.49 |    1287.39 | ▇▁▁▁▁ |
| Bevoelkerung           |         0 |          1.00 | 10203.84 | 53426.40 |   34.00 |  1579.00 |  3535.00 |  8199.00 | 2617175.00 | ▇▁▁▁▁ |
| Bevoelkerungsdichte    |         6 |          1.00 |   405.05 |   771.21 |    2.48 |    62.59 |   151.32 |   399.36 |   12122.83 | ▇▁▁▁▁ |
| Strassen               |       443 |          0.90 |   101.93 |   309.99 |    1.00 |    25.00 |    51.00 |   105.00 |   14970.00 | ▇▁▁▁▁ |
| Inselgemeinde          |         6 |          1.00 |     0.01 |     0.07 |    0.00 |     0.00 |     0.00 |     0.00 |       1.00 | ▇▁▁▁▁ |
| Kuestengemeinde        |         6 |          1.00 |     0.17 |     0.37 |    0.00 |     0.00 |     0.00 |     0.00 |       1.00 | ▇▁▁▁▂ |
| Urbanisierungsgrad     |         6 |          1.00 |     2.49 |     0.59 |    1.00 |     2.00 |     3.00 |     3.00 |       3.00 | ▁▁▆▁▇ |
| Geologischer_Indikator |       285 |          0.93 |     2.29 |     0.89 |    1.00 |     1.00 |     3.00 |     3.00 |       3.00 | ▃▁▂▁▇ |
| Abfaelle_gesamt        |         0 |          1.00 |     5.31 |    32.54 |    0.02 |     0.61 |     1.52 |     3.95 |    1691.89 | ▇▁▁▁▁ |
| Abfaelle_sortiert      |         0 |          1.00 |     3.25 |    15.62 |    0.00 |     0.37 |     1.04 |     2.73 |     765.13 | ▇▁▁▁▁ |
| Abfaelle_unsortiert    |         0 |          1.00 |     2.04 |    17.64 |    0.01 |     0.18 |     0.41 |     1.06 |     926.76 | ▇▁▁▁▁ |
| Sortierungsgrad        |         0 |          1.00 |    60.11 |    19.80 |    0.00 |    44.26 |    64.34 |    76.46 |      97.48 | ▁▃▅▇▅ |
| Sort_Bio               |       511 |          0.88 |    22.28 |    12.75 |    0.01 |    11.13 |    24.98 |    31.84 |      61.64 | ▅▅▇▂▁ |
| Sort_Papier            |        25 |          0.99 |    10.96 |     3.88 |    0.00 |     8.66 |    10.88 |    13.06 |      45.29 | ▃▇▁▁▁ |
| Sort_Glas              |        33 |          0.99 |     9.41 |     3.71 |    0.00 |     7.15 |     9.10 |    11.28 |      39.84 | ▅▇▁▁▁ |
| Sort_Holz              |      1095 |          0.75 |     4.11 |     2.72 |    0.00 |     2.08 |     4.02 |     5.71 |      25.12 | ▇▃▁▁▁ |
| Sort_Metall            |       246 |          0.94 |     1.76 |     1.35 |    0.00 |     0.88 |     1.54 |     2.35 |      20.67 | ▇▁▁▁▁ |
| Sort_Plastik           |        39 |          0.99 |     6.11 |     3.26 |    0.00 |     4.13 |     5.79 |     7.55 |      31.60 | ▇▆▁▁▁ |
| Sort_Elektrik          |       314 |          0.93 |     1.23 |     0.82 |    0.00 |     0.78 |     1.18 |     1.57 |      17.95 | ▇▁▁▁▁ |
| Sort_Textil            |      1013 |          0.77 |     0.76 |     0.69 |    0.00 |     0.35 |     0.63 |     0.99 |      10.58 | ▇▁▁▁▁ |
| Sort_Rest              |       136 |          0.97 |     7.94 |     5.15 |    0.03 |     3.96 |     7.13 |    11.13 |      37.16 | ▇▆▂▁▁ |
| Verwendung_Energie     |         0 |          1.00 |    20.28 |    15.68 |    0.00 |     5.63 |    18.54 |    38.50 |      55.12 | ▇▃▂▇▁ |
| Verwendung_Deponie     |         0 |          1.00 |    17.95 |    19.46 |    0.00 |     4.55 |    11.29 |    31.49 |      76.69 | ▇▁▂▁▁ |
| Verwendung_Recycling   |         0 |          1.00 |    41.29 |    12.84 |    2.35 |    32.68 |    43.23 |    51.57 |      76.69 | ▁▅▇▇▁ |
| Verwendung_Unbekannt   |         0 |          1.00 |    20.47 |    17.82 |    0.00 |     5.21 |    17.77 |    30.98 |      97.38 | ▇▅▂▁▁ |
| Steuern_gewerblich     |       386 |          0.91 | 16564.97 | 14131.50 | 4179.66 |  9079.69 | 12464.90 | 19413.38 |  377492.21 | ▇▁▁▁▁ |
| Steuern_privat         |       285 |          0.93 | 13210.62 |  3648.87 | 2606.01 | 10161.97 | 13667.81 | 15758.65 |   35769.54 | ▂▇▃▁▁ |
| Kosten_Basis           |         0 |          1.00 |   154.24 |    76.07 |   25.69 |   108.04 |   136.62 |   179.16 |     977.42 | ▇▁▁▁▁ |
| Kosten_Sortierung      |        67 |          0.98 |    52.68 |    33.06 |    3.39 |    31.25 |    48.88 |    66.44 |     582.16 | ▇▁▁▁▁ |
| Kosten_sonstiges       |        52 |          0.99 |    54.18 |    43.19 |    4.27 |    27.34 |    41.69 |    66.49 |     670.32 | ▇▁▁▁▁ |

``` r
wm_df %>% complete.cases() %>% sum()
```

    > [1] 2018

There are quite a lot of missing values. Omitting all of them would mean
a loss of more than 50 % of the data. Create some plots to enhance the
understanding of the data set:

``` r
wm_df %>% na.omit %>% 
  ggplot(aes(x=Region, y=Abfaelle_gesamt)) +
  ggtitle("Waste by Region") +
  geom_boxplot(aes(fill = Region), outlier.shape = 2,
               outlier.colour = "black",
               outlier.alpha = .5) +
  theme(aspect.ratio = 0.5) +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position = "none",
        plot.title = element_text(hjust = 0.5))
```

![](ReadMe_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

A lot of outliers in total amounts of waste per community. I am going to
take care of them later. Til then they will be hidden, so other values
appear less compressed.

``` r
wm_df %>% na.omit %>% 
  ggplot(aes(x=Region, y=Abfaelle_gesamt)) +
  ggtitle("Waste by Region") +
  geom_boxplot(aes(fill = Region), outlier.shape = NA) +
  theme(aspect.ratio = 0.5) +
  coord_flip() +
  coord_fixed(ylim = c(0, 29)) +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position = "none",
        plot.title = element_text(hjust = 0.5))
```

![](ReadMe_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
wm_df %>% na.omit %>% 
  mutate(Geologischer_Indikator = ifelse(Geologischer_Indikator == 1, "South", ifelse(Geologischer_Indikator == 2, "Middle", "North"))) %>% 
  ggplot(aes(x=Geologischer_Indikator, y=Abfaelle_gesamt)) +
  ggtitle("Waste by geological location") +
  geom_boxplot(aes(fill = Geologischer_Indikator), outlier.shape = NA) +
  coord_cartesian(ylim = quantile(wm_df$Abfaelle_gesamt, c(0, 0.97))) +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        plot.title = element_text(hjust = 0.5))
```

![](ReadMe_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
wm_df %>%
  na.omit %>%
  mutate(Urbanisierungsgrad =
           ifelse(Urbanisierungsgrad == 1, "low",
                  ifelse(Urbanisierungsgrad == 2, "mid",
                         "high")
  )) %>% 
  ggplot(aes(y=Abfaelle_gesamt)) +
  ggtitle("Waste by population & urbanisation degree") +
  geom_point(aes(x=Bevoelkerung, colour = Urbanisierungsgrad)) +
  theme(plot.title = element_text(hjust = 0.5))
```

![](ReadMe_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
wm_df %>% na.omit %>% 
  mutate(Urbanisierungsgrad = ifelse(Urbanisierungsgrad == 1, "low urbanisation deg.",
                                     ifelse(Urbanisierungsgrad == 3, "high urbanisation deg.",
                                            "mid urbanisation deg."))) %>% 
  ggplot(aes(x=Urbanisierungsgrad, y=Abfaelle_gesamt)) +
  ggtitle("Mean waste by urbanisation degree") +
  stat_summary(aes(group = Urbanisierungsgrad, fill = Urbanisierungsgrad), fun = mean, geom = "bar") +
  labs(y = "mean(Abfaelle_gesamt)") +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        plot.title = element_text(hjust = 0.5))
```

![](ReadMe_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

Inspecting missing values within the waste sorting related columns:

``` r
sapply(wm_df[,16:25],
       function(y) sum(length(which(is.na(y))))) %>%
  tibble(Column = names(.),
         NA_Count = .)
```

    > # A tibble: 10 × 2
    >    Column          NA_Count
    >    <chr>              <int>
    >  1 Sortierungsgrad        0
    >  2 Sort_Bio             511
    >  3 Sort_Papier           25
    >  4 Sort_Glas             33
    >  5 Sort_Holz           1095
    >  6 Sort_Metall          246
    >  7 Sort_Plastik          39
    >  8 Sort_Elektrik        314
    >  9 Sort_Textil         1013
    > 10 Sort_Rest            136

``` r
options(width = 200)
Sort_NAs <- c()
for (i in 17:25) {
  nas_t <- which(is.na(wm_df[i]))
  Sort_NAs <- c(Sort_NAs, nas_t)
}

Sort_NAs_table <- Sort_NAs %>% table %>% sort(decreasing = T)
Sort_NAs_table[1:5] %>% names %>% as.numeric -> t

wm_df[t,16:25]
```

    >      Sortierungsgrad Sort_Bio Sort_Papier Sort_Glas Sort_Holz Sort_Metall Sort_Plastik Sort_Elektrik Sort_Textil Sort_Rest
    > 429             0.72       NA        0.72        NA        NA          NA           NA            NA          NA        NA
    > 3572            0.70       NA          NA        NA        NA          NA           NA           0.7          NA        NA
    > 4175            0.00       NA          NA        NA        NA          NA           NA           0.0          NA        NA
    > 3777           59.32       NA          NA     39.84        NA          NA           NA            NA          NA     19.48
    > 4017            1.87       NA          NA        NA        NA          NA         0.62            NA          NA      1.25

Looks like the sum of the values present in these waste sorting columns
equals the value in *Sortierungsgrad*. Imputing any values here would
completely destroy the logic behind these columns. I would argue that
dropping all these values is a viable option. However, one could also
say that replacing these NAs with zeros instead might work out as well.
The latter option is the one I chose.

## Dimension Reduction

Within the data set there are dimensions that hold no value when it
comes to any analyses. *ID* is a unique identifier, *Gemeinde* the name
of a community, *Strassen* contains more than 10 % missing values,
*Region* and *Provinz* contain too many unique values that would
complicate the process a lot. Also the importance of the information
they hold is questionable.

``` r
cols_to_exclude <- c("ID",
                     "Gemeinde",
                     "Strassen",
                     "Region",
                     "Provinz")
```

A vector containing the names of the columns mentioned is created. A
recipe from the *tidyverse* is used to remove these dimensions, replace
missing values via bag imputation and replace outliers in numeric
dimension with the IQR limits of their individual column and replace the
remaining nominal columns with dummy variables.

Note: *step_impute_constant()* and *step_outliers_iqr_to_limits()* are
functions from the *steffanossaR* package found at
<https://github.com/steffanossa/steffanossaR>.

``` r
recipe_prep <- recipe(~., data = wm_df) %>% 
  step_rm(all_of(cols_to_exclude)) %>% 
  step_impute_constant(contains("Sort_"), constant = 0) %>% 
  step_impute_bag(all_numeric()) %>% 
  step_outliers_iqr_to_limits(all_numeric(), -ends_with("gemeinde")) %>% 
  step_other(all_nominal(), threshold = .001, other = NA) %>% 
  step_naomit(everything(), skip = T) %>% 
  step_dummy(all_nominal()) %>% 
  step_zv(everything())
```

### Principal Components Analysis (PCA)

A PCA is used to reduce the number of variables by finding principal
components of the data, which are new and uncorrelated variables that
can explain the most variance in the original data.

First, the Bartlett test is done. The Bartlett test verifies the null
hypothesis that the correlation matrix is equal to the identity matrix,
meaning that the variables of a given data set are uncorrelated. If the
resulting value is below .05, the null hypothesis is rejected and it is
concluded, that the variables are correlated[^2].

``` r
psych::cortest.bartlett(cor(wm_df_prepped), n = 100)
```

    > $chisq
    > [1] 2561.047
    > 
    > $p.value
    > [1] 7.701122e-286
    > 
    > $df
    > [1] 465

The value is way below 0.05, there is correlation between the dimensions
of the data set.

Next, the Kaiser-Mayer-Olkin Criterion (KMO) is looked at. The KMO
measures the adequacy of a data set for factor analysis. It ranges from
0 to 1, where a higher value indicates higher suitability. A value above
.6 is generally considered to be the threshold. However, some sources
also consider .5 to be acceptable[^3].

``` r
psych::KMO(wm_df_prepped)$MSA
```

    > [1] 0.5676481

0.5676481 is not very good but I will consider this acceptable. Now the
PCA can be executed.

``` r
options(width = 90)
wm_df_pca <- 
  wm_df_prepped %>% 
  prcomp(scale. = T,
         center = T)
wm_df_pca %>%
  summary()
```

    > Importance of components:
    >                           PC1    PC2     PC3    PC4     PC5     PC6     PC7     PC8
    > Standard deviation     2.5686 2.3601 1.59393 1.3512 1.25932 1.15609 1.03771 1.02230
    > Proportion of Variance 0.2128 0.1797 0.08195 0.0589 0.05116 0.04311 0.03474 0.03371
    > Cumulative Proportion  0.2128 0.3925 0.47447 0.5334 0.58452 0.62764 0.66237 0.69609
    >                            PC9    PC10    PC11    PC12   PC13    PC14    PC15    PC16
    > Standard deviation     0.96946 0.95616 0.91394 0.88242 0.8589 0.80276 0.79644 0.76424
    > Proportion of Variance 0.03032 0.02949 0.02694 0.02512 0.0238 0.02079 0.02046 0.01884
    > Cumulative Proportion  0.72640 0.75590 0.78284 0.80796 0.8317 0.85254 0.87300 0.89184
    >                           PC17    PC18    PC19    PC20    PC21    PC22    PC23    PC24
    > Standard deviation     0.74115 0.69009 0.64909 0.60811 0.55917 0.54521 0.47392 0.45181
    > Proportion of Variance 0.01772 0.01536 0.01359 0.01193 0.01009 0.00959 0.00725 0.00658
    > Cumulative Proportion  0.90956 0.92492 0.93852 0.95044 0.96053 0.97012 0.97736 0.98395
    >                           PC25    PC26    PC27    PC28    PC29    PC30    PC31
    > Standard deviation     0.43253 0.39176 0.32432 0.17296 0.09736 0.08770 0.06888
    > Proportion of Variance 0.00603 0.00495 0.00339 0.00096 0.00031 0.00025 0.00015
    > Cumulative Proportion  0.98998 0.99494 0.99833 0.99929 0.99960 0.99985 1.00000

Taking a look at the first 15 principal components (PC) and the
percentage of variance they explain.

``` r
wm_df_pca %>%
  factoextra::fviz_eig(ncp = 15,
                       addlabels = T)
```

![](ReadMe_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

The *elbow method* would suggest using three PCs. The cumulative
variance of 49.942 % when taking only three is too little to result in
useful outcomes.

Another method of evaluating the number of PCs to keep is the *Kaiser
Criterion* which states that factors with an eigenvalue above 1 are
considered important and should be retained. An eigenvalue above 1 means
its factor explains more variance than a single variable would.

``` r
factoextra::get_eig(wm_df_pca) %>%
  filter(eigenvalue > 1)
```

    >       eigenvalue variance.percent cumulative.variance.percent
    > Dim.1   6.597706        21.282924                    21.28292
    > Dim.2   5.570200        17.968387                    39.25131
    > Dim.3   2.540597         8.195475                    47.44679
    > Dim.4   1.825792         5.889653                    53.33644
    > Dim.5   1.585895         5.115790                    58.45223
    > Dim.6   1.336539         4.311415                    62.76364
    > Dim.7   1.076833         3.473654                    66.23730
    > Dim.8   1.045094         3.371272                    69.60857

8 factors possess eigenvalues above 1 with a cumulative variance of
69.61 %.

``` r
get_eig(wm_df_pca)[1:15,] %>% 
  ggplot(aes(y=eigenvalue, x=1:15)) +
  ggtitle("Eigenvalue by Component") +
  labs(x = "Component",
       y = "Eigenvalue") +
  geom_line() +
  geom_point(col = "blue") +
  scale_x_continuous(breaks = 1:15) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  theme(plot.title = element_text(hjust = 0.5))
```

![](ReadMe_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

A third approach is *Horn’s Method*. Here random data sets with equal
size (columns and rows) as the original data set are generated and then
a factor analysis is performed on each of them. The retained number of
factors are then compared. The idea is that if the number of factors
kept in the original data set is similar to the number of factors kept
in the random sets, the factors of the original data set are considered
not meaningful. If the number of factors of the original data set is
larger than the number of factors in the random sets, the factors in the
original data set are considered meaningful[^4].

``` r
wm_df_prepped %>%
  paran::paran()
```

    > 
    > Using eigendecomposition of correlation matrix.
    > Computing: 10%  20%  30%  40%  50%  60%  70%  80%  90%  100%
    > 
    > 
    > Results of Horn's Parallel Analysis for component retention
    > 930 iterations, using the mean estimate
    > 
    > -------------------------------------------------- 
    > Component   Adjusted    Unadjusted    Estimated 
    >             Eigenvalue  Eigenvalue    Bias 
    > -------------------------------------------------- 
    > 1           6.439941    6.597706      0.157765
    > 2           5.431598    5.570200      0.138601
    > 3           2.416818    2.540597      0.123778
    > 4           1.714614    1.825792      0.111177
    > 5           1.486536    1.585894      0.099358
    > 6           1.248106    1.336538      0.088432
    > -------------------------------------------------- 
    > 
    > Adjusted eigenvalues > 1 indicate dimensions to retain.
    > (6 components retained)

*Horn’s Method* suggests a number of 6 PCs to keep. I chose to keep 8
with approximately 69.61 % cumulative variance. Next, we take a look at
the contributions of the original variables to each new PC.

``` r
n_PCs <- 8
for (i in 1:n_PCs) {
  factoextra::fviz_contrib(wm_df_pca, "var", axes = i) %>%
    print
}
```

![](ReadMe_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

The *psych* package comes with a function that can illustrate the
contribution of each original variable to the PCs in one plot.

``` r
wm_df_prepped %>%
  psych::principal(nfactors = n_PCs) %>%
  psych::fa.diagram()
```

![](ReadMe_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

A new data set is created based on the new dimensions.

``` r
wm_df_transformed_pca <-
  as.data.frame(-wm_df_pca$x[,1:n_PCs])
```

### Factor Analysis (FA)

Like the PCA a factor analysis can be used to reduce the dimensions of a
data set. However, while the PCA creates uncorrelated variables the FA
identifies underlying latent factors that explain the relationships
among the original variables in the data set. The factors the FA puts
out might be correlated, so a rotation can be used in make these factors
as uncorrelated as possible.

First, a vector containing all rotation methods is created. Then we
iterate over each of them using a for-loop.

``` r
options(width = 300)
rot_meth <- c("varimax",
              "quartimax",
              "equamax",
              "oblimin",
              "promax")
max_cumvar <- 0
for (rm in rot_meth) {
  cat("Factor Analysis results. Rotation method: ", rm, "\n")
  res <- factanal(wm_df_prepped,
                  factors = n_PCs,
                  rotation = rm,
                  lower = 0.1) %>% 
    steffanossaR::ex_factanal()
  if (res[3,n_PCs] > max_cumvar & res[3,n_PCs] <= 1) {max_cumvar <- res[3,n_PCs]}
  print(res)
  cat("\n")
}
```

    > Factor Analysis results. Rotation method:  varimax 
    >                  Factor1   Factor2    Factor3    Factor4    Factor5    Factor6   Factor7    Factor8
    > SS loadings    5.2611890 4.2162158 2.43124239 1.73061396 1.47272740 1.38197945 1.1766948 1.16858818
    > Proportion Var 0.1697158 0.1360070 0.07842717 0.05582626 0.04750734 0.04457998 0.0379579 0.03769639
    > Cumulative Var 0.1697158 0.3057227 0.38414991 0.43997617 0.48748350 0.53206348 0.5700214 0.60771777
    > 
    > Factor Analysis results. Rotation method:  quartimax 
    >                 Factor1   Factor2   Factor3    Factor4    Factor5    Factor6    Factor7    Factor8
    > SS loadings    5.234009 4.2420000 3.2360085 1.64195764 1.33474382 1.32226242 1.08838159 0.73988800
    > Proportion Var 0.168839 0.1368387 0.1043874 0.05296638 0.04305625 0.04265363 0.03510908 0.02386735
    > Cumulative Var 0.168839 0.3056777 0.4100651 0.46303146 0.50608771 0.54874134 0.58385042 0.60771777
    > 
    > Factor Analysis results. Rotation method:  equamax 
    >                  Factor1    Factor2    Factor3    Factor4   Factor5    Factor6    Factor7    Factor8
    > SS loadings    4.3613843 2.95869154 2.56321140 1.98795414 1.9042557 1.90138056 1.72317550 1.43919787
    > Proportion Var 0.1406898 0.09544166 0.08268424 0.06412755 0.0614276 0.06133486 0.05558631 0.04642574
    > Cumulative Var 0.1406898 0.23613148 0.31881572 0.38294327 0.4443709 0.50570573 0.56129204 0.60771777
    > 
    > Factor Analysis results. Rotation method:  oblimin 
    >                  Factor1   Factor2    Factor3    Factor4    Factor5    Factor6    Factor7    Factor8
    > SS loadings    4.4333756 3.1363599 1.91260898 1.73922860 1.48201583 1.48142710 1.36642175 1.33977209
    > Proportion Var 0.1430121 0.1011729 0.06169706 0.05610415 0.04780696 0.04778797 0.04407812 0.04321845
    > Cumulative Var 0.1430121 0.2441850 0.30588208 0.36198623 0.40979319 0.45758116 0.50165928 0.54487774
    > 
    > Factor Analysis results. Rotation method:  promax 
    >                  Factor1   Factor2   Factor3    Factor4    Factor5    Factor6    Factor7    Factor8
    > SS loadings    5.0056292 3.6362613 3.6135294 1.72303154 1.50016567 1.46091163 1.44619926 0.91448483
    > Proportion Var 0.1614719 0.1172988 0.1165655 0.05558166 0.04839244 0.04712618 0.04665159 0.02949951
    > Cumulative Var 0.1614719 0.2787707 0.3953361 0.45091779 0.49931023 0.54643641 0.59308800 0.62258751

0.6225875 % is the maximum amount of cumulative variance with 8 factors.
Approximately 10 % less than what the PCA yielded. Therefore PCA will be
used.

## Cluster Analysis

To assess the clustering tendency of a data set the *Hopkins Statistic*
can be used. It measures the probability that a given data set was
generated by a uniform data distribution. The higher the resulting value
the better the clustering tendency. Values range from 0 to 1[^5].

``` r
#wm_df_transformed_pca %>%
#  get_clust_tendency(n = nrow(wm_df_transformed_pca) - 1, graph = F)
```

\~ 0.83 is quite good.

### Hierarchical Clustering: Agglomerative Methods

Clustering can be done with different approaches. Agglomerative methods
start with a cluster containing a single observation, adding more and
more observations successively. First, a distance matrix and then
clusters are created. For both steps there are multiple methods of
creation.

``` r
dist_meth <- c("euclidean",
               "maximum",
               "manhattan",
               "canberra",
               "minkowski")

clust_meth <- c("single",
                "complete",
                "average",
                "cquitty",
                "median",
                "centroid",
                "ward.D2")
#' *...*
```

The combination of *Canberra* and *ward.D2* looks most promising.

``` r
hclust_a <- 
  dist(scale(wm_df_transformed_pca), 
       method = "canberra") %>% 
  hclust(method = "ward.D2")
 
hclust_a %>% plot
```

![](ReadMe_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

``` r
# ggdendrogram(hclust_a, leaf_labels = F, labels = F) +
#   labs(title = paste0("Distance: Canberra", "\nCluster: ward.D2"))
```

The amount of viable clusters seems to range from 2 to 7. Microsoft
Excel can be used to comfortably compare clusters for profiling and help
determining the number of clusters to choose.

**to be continued**

[^1]: Municipal waste is all waste collected and treated by or for
    municipalities. It includes waste from households, including bulky
    waste, similar waste from trade and commerce, office buildings,
    institutions and small businesses, as well as yard and garden waste,
    street sweepings and the contents of waste containers. The
    definition excludes waste from municipal sewage systems and their
    treatment, as well as waste from construction and demolition work.

[^2]: Reference:
    <https://www.itl.nist.gov/div898/handbook/eda/section3/eda357.htm>

[^3]: Reference:
    <https://www.empirical-methods.hslu.ch/entscheidbaum/interdependenzanalyse/reduktion-der-variablen/faktoranalyse/>

[^4]: Reference: <doi:10.1007/bf02289447>

[^5]: Reference:
    <https://www.datanovia.com/en/lessons/assessing-clustering-tendency/>
