Derivation of Waste Management Profiles
================
steffanossa
last-modified

## Context

Although only about 15% of all waste within the EU is generated as
municipal waste\[^1\], the absolute figures pose a major problem for
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
also geographical and economic factors. \[^1\]: Municipal waste is all
waste collected and treated by or for municipalities. It includes waste
from households including bulky waste, similar waste from trade and
commerce, office buildings, institutions and small businesses, as well
as yard and garden waste, street sweepings and the contents of waste
containers. yard and garden waste, street sweepings and the contents of
waste containers. The definition includes waste from municipal sewage
networks and their treatment as well as waste from construction and
demolition work.

## Exploratory Data Analysis

Get an overview of what the data set is about.

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

    ## [1] 2018

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

![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

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

    ## Coordinate system already present. Adding new coordinate system, which will
    ## replace the existing one.

![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

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

![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

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

![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

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

![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

Inspecting missing values within the waste sorting related columns:

``` r
sapply(wm_df[,16:25],
       function(y) sum(length(which(is.na(y))))) %>%
  tibble(Column = names(.),
         NA_Count = .)
```

    ## # A tibble: 10 × 2
    ##    Column          NA_Count
    ##    <chr>              <int>
    ##  1 Sortierungsgrad        0
    ##  2 Sort_Bio             511
    ##  3 Sort_Papier           25
    ##  4 Sort_Glas             33
    ##  5 Sort_Holz           1095
    ##  6 Sort_Metall          246
    ##  7 Sort_Plastik          39
    ##  8 Sort_Elektrik        314
    ##  9 Sort_Textil         1013
    ## 10 Sort_Rest            136

``` r
Sort_NAs <- c()
for (i in 17:25) {
  nas_t <- which(is.na(wm_df[i]))
  Sort_NAs <- c(Sort_NAs, nas_t)
}

Sort_NAs_table <- Sort_NAs %>% table %>% sort(decreasing = T)
Sort_NAs_table[1:5] %>% names %>% as.numeric -> t

wm_df[t,16:25]
```

    ##      Sortierungsgrad Sort_Bio Sort_Papier Sort_Glas Sort_Holz Sort_Metall
    ## 429             0.72       NA        0.72        NA        NA          NA
    ## 3572            0.70       NA          NA        NA        NA          NA
    ## 4175            0.00       NA          NA        NA        NA          NA
    ## 3777           59.32       NA          NA     39.84        NA          NA
    ## 4017            1.87       NA          NA        NA        NA          NA
    ##      Sort_Plastik Sort_Elektrik Sort_Textil Sort_Rest
    ## 429            NA            NA          NA        NA
    ## 3572           NA           0.7          NA        NA
    ## 4175           NA           0.0          NA        NA
    ## 3777           NA            NA          NA     19.48
    ## 4017         0.62            NA          NA      1.25

Looks like the sum of the values present in these waste sorting columns
equals the value in Sortierungsgrad. Imputing any values here would
completely destroy the logic behind these columns. I would argue that
dropping all these values is a viable option. However, one could also
say that replacing these NAs with zeros instead might work out as well.
The latter option is the one I chose.

## Dimension Reduction

Within the data set there are dimensions that hold no value when it
comes to any analyses. “ID” is a unique identifier, “Gemeinde” the name
of a community, “Strassen” contains more than 10 % missing values,
“Region” and “Provinz” contain too many unique values that would
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
concluded, that the variables are correlated.

(Reference:
<https://www.itl.nist.gov/div898/handbook/eda/section3/eda357.htm>)

``` r
psych::cortest.bartlett(cor(wm_df_prepped), n = 100)
```

    ## $chisq
    ## [1] 2565.479
    ## 
    ## $p.value
    ## [1] 1.252629e-286
    ## 
    ## $df
    ## [1] 465

The value is way below 0.05, there is correlation between the dimensions
of the data set.

Next, the Kaiser-Mayer-Olkin Criterion (KMO) is looked at. The KMO
measures the adequacy of a dataset for factor analysis. It ranges from 0
to 1, where a higher value indicates higher suitability. A value above
.6 is generally considered to be the threshold. However, some sources
also consider .5 to be acceptable.

(Reference:
<https://www.empirical-methods.hslu.ch/entscheidbaum/interdependenzanalyse/reduktion-der-variablen/faktoranalyse/>)

``` r
psych::KMO(wm_df_prepped)$MSA
```

    ## [1] 0.5685659

\~0.57 is not very good but I will consider this acceptable. Now the PCA
can be executed.

``` r
wm_df_pca <- 
  wm_df_prepped %>% 
  prcomp(scale. = T,
         center = T)
wm_df_pca %>%
  summary()
```

    ## Importance of components:
    ##                           PC1    PC2     PC3     PC4    PC5     PC6     PC7
    ## Standard deviation     2.5713 2.3624 1.59165 1.34938 1.2599 1.15557 1.03787
    ## Proportion of Variance 0.2133 0.1800 0.08172 0.05874 0.0512 0.04308 0.03475
    ## Cumulative Proportion  0.2133 0.3933 0.47503 0.53377 0.5850 0.62805 0.66279
    ##                            PC8     PC9    PC10    PC11    PC12    PC13   PC14
    ## Standard deviation     1.02086 0.96904 0.95477 0.91403 0.88153 0.85785 0.8029
    ## Proportion of Variance 0.03362 0.03029 0.02941 0.02695 0.02507 0.02374 0.0208
    ## Cumulative Proportion  0.69641 0.72670 0.75611 0.78306 0.80813 0.83187 0.8527
    ##                           PC15    PC16    PC17    PC18    PC19   PC20    PC21
    ## Standard deviation     0.79822 0.76400 0.74106 0.69018 0.64890 0.6099 0.55871
    ## Proportion of Variance 0.02055 0.01883 0.01772 0.01537 0.01358 0.0120 0.01007
    ## Cumulative Proportion  0.87322 0.89205 0.90976 0.92513 0.93871 0.9507 0.96078
    ##                           PC22    PC23   PC24    PC25    PC26    PC27    PC28
    ## Standard deviation     0.54514 0.47389 0.4522 0.43084 0.38348 0.32428 0.17289
    ## Proportion of Variance 0.00959 0.00724 0.0066 0.00599 0.00474 0.00339 0.00096
    ## Cumulative Proportion  0.97036 0.97761 0.9842 0.99019 0.99494 0.99833 0.99929
    ##                           PC29    PC30    PC31
    ## Standard deviation     0.09752 0.08771 0.06889
    ## Proportion of Variance 0.00031 0.00025 0.00015
    ## Cumulative Proportion  0.99960 0.99985 1.00000

Taking a look at the first 15 principal components (PC) and the
percentage of variance they explain.

``` r
wm_df_pca %>%
  factoextra::fviz_eig(ncp = 15,
                       addlabels = T)
```

![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

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

    ##       eigenvalue variance.percent cumulative.variance.percent
    ## Dim.1   6.611644        21.327884                    21.32788
    ## Dim.2   5.580969        18.003124                    39.33101
    ## Dim.3   2.533352         8.172103                    47.50311
    ## Dim.4   1.820828         5.873638                    53.37675
    ## Dim.5   1.587278         5.120253                    58.49700
    ## Dim.6   1.335336         4.307536                    62.80454
    ## Dim.7   1.077166         3.474730                    66.27927
    ## Dim.8   1.042163         3.361815                    69.64108

8 factors possess eigenvalues above 1 with a cumulative variance of
69.62810 %. A third approach is *Horn’s Method*. Here random data sets
with equal size (columns and rows) as the original data set are
generated and then a factor analysis is performed on each of them. The
retained number of factors are then compared. The idea is that if the
number of factors kept in the original data set is similar to the number
of factors kept in the random sets, the factors of the original data set
are considered not meaningful. If the number of factors of the original
data set is larger than the number of factors in the random sets, the
factors in the original data set are considered meaningful.

``` r
wm_df_prepped %>%
  paran::paran()
```

    ## 
    ## Using eigendecomposition of correlation matrix.
    ## Computing: 10%  20%  30%  40%  50%  60%  70%  80%  90%  100%
    ## 
    ## 
    ## Results of Horn's Parallel Analysis for component retention
    ## 930 iterations, using the mean estimate
    ## 
    ## -------------------------------------------------- 
    ## Component   Adjusted    Unadjusted    Estimated 
    ##             Eigenvalue  Eigenvalue    Bias 
    ## -------------------------------------------------- 
    ## 1           6.454097    6.611644      0.157547
    ## 2           5.442660    5.580968      0.138308
    ## 3           2.409584    2.533351      0.123767
    ## 4           1.709922    1.820827      0.110905
    ## 5           1.487982    1.587278      0.099296
    ## 6           1.246912    1.335336      0.088423
    ## -------------------------------------------------- 
    ## 
    ## Adjusted eigenvalues > 1 indicate dimensions to retain.
    ## (6 components retained)

*Horn’s Method* suggests a number of 6 PCs to keep. I chose to keep 8
with approximately 70 % cumulative variance. Next, we take a look at the
contributions of the original variables to each new PC.

``` r
n_PCs <- 8
for (i in 1:n_PCs) {
  factoextra::fviz_contrib(wm_df_pca, "var", axes = i) %>%
    print
}
```

![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-18-2.png)<!-- -->![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-18-3.png)<!-- -->![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-18-4.png)<!-- -->![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-18-5.png)<!-- -->![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-18-6.png)<!-- -->![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-18-7.png)<!-- -->![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-18-8.png)<!-- -->

The *psych* package comes with a function that can illustrate the
contribution of each original variable to the PCs in one plot.

``` r
wm_df_prepped %>%
  psych::principal(nfactors = n_PCs) %>%
  psych::fa.diagram()
```

![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

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
rot_meth <- c("varimax",
              "quartimax",
              "equamax",
              "oblimin",
              "oblimax",
              "promax")

for (rm in rot_meth) {
  invisible(
    readline(
      prompt=paste0("[enter] to show next rotation result")))
  cat("Factor Analysis results. Rotation method: ", rm)
  wm_df_prepped %>%
    factanal(factors = n_PCs,
             rotation = rm,
             lower = 0.1) %>% 
    print
}
```

    ## [enter] to show next rotation result
    ## Factor Analysis results. Rotation method:  varimax
    ## Call:
    ## factanal(x = ., factors = n_PCs, rotation = rm, lower = 0.1)
    ## 
    ## Uniquenesses:
    ##                    Flaeche               Bevoelkerung 
    ##                      0.368                      0.100 
    ##        Bevoelkerungsdichte              Inselgemeinde 
    ##                      0.108                      0.969 
    ##            Kuestengemeinde         Urbanisierungsgrad 
    ##                      0.705                      0.319 
    ##     Geologischer_Indikator            Abfaelle_gesamt 
    ##                      0.151                      0.100 
    ##          Abfaelle_sortiert        Abfaelle_unsortiert 
    ##                      0.100                      0.100 
    ##            Sortierungsgrad                   Sort_Bio 
    ##                      0.100                      0.100 
    ##                Sort_Papier                  Sort_Glas 
    ##                      0.587                      0.709 
    ##                  Sort_Holz                Sort_Metall 
    ##                      0.481                      0.644 
    ##               Sort_Plastik              Sort_Elektrik 
    ##                      0.680                      0.779 
    ##                Sort_Textil                  Sort_Rest 
    ##                      0.922                      0.581 
    ##         Verwendung_Energie         Verwendung_Deponie 
    ##                      0.100                      0.100 
    ##       Verwendung_Recycling       Verwendung_Unbekannt 
    ##                      0.285                      0.100 
    ##         Steuern_gewerblich             Steuern_privat 
    ##                      0.575                      0.289 
    ##               Kosten_Basis          Kosten_Sortierung 
    ##                      0.100                      0.698 
    ##           Kosten_sonstiges Gebuehrenregelung_STANDARD 
    ##                      0.460                      0.841 
    ##           Region_PAYT_Nein 
    ##                      0.238 
    ## 
    ## Loadings:
    ##                            Factor1 Factor2 Factor3 Factor4 Factor5 Factor6
    ## Flaeche                     0.243  -0.120                   0.724         
    ## Bevoelkerung                0.964                                         
    ## Bevoelkerungsdichte         0.651   0.117                  -0.669         
    ## Inselgemeinde                                       0.169                 
    ## Kuestengemeinde             0.220  -0.281           0.322                 
    ## Urbanisierungsgrad         -0.725                           0.383         
    ## Geologischer_Indikator              0.896          -0.127  -0.100         
    ## Abfaelle_gesamt             0.959                   0.109   0.120         
    ## Abfaelle_sortiert           0.943   0.126                   0.102         
    ## Abfaelle_unsortiert         0.880          -0.261   0.144   0.126         
    ## Sortierungsgrad            -0.315   0.317   0.633  -0.107  -0.132   0.165 
    ## Sort_Bio                   -0.402           0.352          -0.105   0.140 
    ## Sort_Papier                 0.187   0.254   0.451  -0.110           0.179 
    ## Sort_Glas                  -0.316           0.409                         
    ## Sort_Holz                   0.181   0.651   0.166          -0.111   0.127 
    ## Sort_Metall                -0.133   0.439   0.372                         
    ## Sort_Plastik                       -0.101   0.544                         
    ## Sort_Elektrik                       0.264   0.373                         
    ## Sort_Textil                                 0.252                         
    ## Sort_Rest                           0.492   0.262          -0.206   0.110 
    ## Verwendung_Energie                  0.419          -0.152  -0.202   0.175 
    ## Verwendung_Deponie                 -0.500  -0.113           0.219   0.630 
    ## Verwendung_Recycling       -0.214   0.414   0.599          -0.123         
    ## Verwendung_Unbekannt               -0.117  -0.236   0.101          -0.866 
    ## Steuern_gewerblich         -0.314  -0.338           0.338   0.197  -0.226 
    ## Steuern_privat              0.177   0.808                                 
    ## Kosten_Basis                       -0.111  -0.222   0.896   0.133         
    ## Kosten_Sortierung           0.140           0.202   0.460                 
    ## Kosten_sonstiges           -0.117  -0.184  -0.425   0.509                 
    ## Gebuehrenregelung_STANDARD         -0.327  -0.112   0.111  -0.126         
    ## Region_PAYT_Nein                   -0.810           0.199                 
    ##                            Factor7 Factor8
    ## Flaeche                             0.125 
    ## Bevoelkerung                              
    ## Bevoelkerungsdichte                       
    ## Inselgemeinde                             
    ## Kuestengemeinde                     0.229 
    ## Urbanisierungsgrad                        
    ## Geologischer_Indikator                    
    ## Abfaelle_gesamt                           
    ## Abfaelle_sortiert                         
    ## Abfaelle_unsortiert        -0.116         
    ## Sortierungsgrad             0.524         
    ## Sort_Bio                    0.767         
    ## Sort_Papier                         0.250 
    ## Sort_Glas                          -0.102 
    ## Sort_Holz                                 
    ## Sort_Metall                               
    ## Sort_Plastik                              
    ## Sort_Elektrik                             
    ## Sort_Textil                               
    ## Sort_Rest                          -0.219 
    ## Verwendung_Energie                 -0.798 
    ## Verwendung_Deponie                  0.448 
    ## Verwendung_Recycling        0.350         
    ## Verwendung_Unbekannt       -0.165   0.220 
    ## Steuern_gewerblich                        
    ## Steuern_privat                            
    ## Kosten_Basis                              
    ## Kosten_Sortierung           0.129         
    ## Kosten_sonstiges           -0.199         
    ## Gebuehrenregelung_STANDARD                
    ## Region_PAYT_Nein                    0.232 
    ## 
    ##                Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
    ## SS loadings      5.262   4.240   2.439   1.727   1.473   1.373   1.173   1.165
    ## Proportion Var   0.170   0.137   0.079   0.056   0.048   0.044   0.038   0.038
    ## Cumulative Var   0.170   0.306   0.385   0.441   0.488   0.533   0.571   0.608
    ## 
    ## Test of the hypothesis that 8 factors are sufficient.
    ## The chi square statistic is 32134.73 on 245 degrees of freedom.
    ## The p-value is 0 
    ## [enter] to show next rotation result
    ## Factor Analysis results. Rotation method:  quartimax
    ## Call:
    ## factanal(x = ., factors = n_PCs, rotation = rm, lower = 0.1)
    ## 
    ## Uniquenesses:
    ##                    Flaeche               Bevoelkerung 
    ##                      0.368                      0.100 
    ##        Bevoelkerungsdichte              Inselgemeinde 
    ##                      0.108                      0.969 
    ##            Kuestengemeinde         Urbanisierungsgrad 
    ##                      0.705                      0.319 
    ##     Geologischer_Indikator            Abfaelle_gesamt 
    ##                      0.151                      0.100 
    ##          Abfaelle_sortiert        Abfaelle_unsortiert 
    ##                      0.100                      0.100 
    ##            Sortierungsgrad                   Sort_Bio 
    ##                      0.100                      0.100 
    ##                Sort_Papier                  Sort_Glas 
    ##                      0.587                      0.709 
    ##                  Sort_Holz                Sort_Metall 
    ##                      0.481                      0.644 
    ##               Sort_Plastik              Sort_Elektrik 
    ##                      0.680                      0.779 
    ##                Sort_Textil                  Sort_Rest 
    ##                      0.922                      0.581 
    ##         Verwendung_Energie         Verwendung_Deponie 
    ##                      0.100                      0.100 
    ##       Verwendung_Recycling       Verwendung_Unbekannt 
    ##                      0.285                      0.100 
    ##         Steuern_gewerblich             Steuern_privat 
    ##                      0.575                      0.289 
    ##               Kosten_Basis          Kosten_Sortierung 
    ##                      0.100                      0.698 
    ##           Kosten_sonstiges Gebuehrenregelung_STANDARD 
    ##                      0.460                      0.841 
    ##           Region_PAYT_Nein 
    ##                      0.238 
    ## 
    ## Loadings:
    ##                            Factor1 Factor2 Factor3 Factor4 Factor5 Factor6
    ## Flaeche                     0.297  -0.166  -0.143           0.681         
    ## Bevoelkerung                0.967          -0.100                         
    ## Bevoelkerungsdichte         0.600   0.143                  -0.700         
    ## Inselgemeinde                                       0.163                 
    ## Kuestengemeinde             0.228  -0.312           0.290  -0.113         
    ## Urbanisierungsgrad         -0.695                           0.427         
    ## Geologischer_Indikator              0.912                                 
    ## Abfaelle_gesamt             0.969          -0.125                         
    ## Abfaelle_sortiert           0.957                                         
    ## Abfaelle_unsortiert         0.883          -0.295   0.113                 
    ## Sortierungsgrad            -0.301   0.240   0.866  -0.119          -0.116 
    ## Sort_Bio                   -0.405           0.805                         
    ## Sort_Papier                 0.212   0.191   0.345  -0.152          -0.187 
    ## Sort_Glas                  -0.303           0.254                         
    ## Sort_Holz                   0.192   0.634   0.203                  -0.127 
    ## Sort_Metall                -0.110   0.407   0.284                         
    ## Sort_Plastik                       -0.162   0.439                         
    ## Sort_Elektrik                       0.219   0.271           0.112         
    ## Sort_Textil                                 0.210  -0.107                 
    ## Sort_Rest                           0.488   0.231          -0.154         
    ## Verwendung_Energie                  0.490          -0.109  -0.150  -0.142 
    ## Verwendung_Deponie                 -0.533  -0.165           0.144  -0.655 
    ## Verwendung_Recycling       -0.191   0.340   0.725                         
    ## Verwendung_Unbekannt                       -0.350                   0.837 
    ## Steuern_gewerblich         -0.285  -0.361  -0.105   0.323   0.191   0.228 
    ## Steuern_privat              0.187   0.803   0.121                         
    ## Kosten_Basis                0.147  -0.177  -0.189   0.897                 
    ## Kosten_Sortierung           0.181  -0.139   0.239   0.421                 
    ## Kosten_sonstiges                   -0.177  -0.439   0.540                 
    ## Gebuehrenregelung_STANDARD         -0.307  -0.165          -0.149         
    ## Region_PAYT_Nein                   -0.836           0.117                 
    ##                            Factor7 Factor8
    ## Flaeche                     0.135         
    ## Bevoelkerung                              
    ## Bevoelkerungsdichte                       
    ## Inselgemeinde                             
    ## Kuestengemeinde             0.199         
    ## Urbanisierungsgrad                        
    ## Geologischer_Indikator                    
    ## Abfaelle_gesamt                           
    ## Abfaelle_sortiert                         
    ## Abfaelle_unsortiert                -0.121 
    ## Sortierungsgrad                           
    ## Sort_Bio                           -0.302 
    ## Sort_Papier                 0.267   0.281 
    ## Sort_Glas                           0.326 
    ## Sort_Holz                           0.121 
    ## Sort_Metall                         0.305 
    ## Sort_Plastik                        0.312 
    ## Sort_Elektrik                       0.288 
    ## Sort_Textil                         0.127 
    ## Sort_Rest                  -0.189   0.234 
    ## Verwendung_Energie         -0.785         
    ## Verwendung_Deponie          0.386         
    ## Verwendung_Recycling                0.181 
    ## Verwendung_Unbekannt        0.255         
    ## Steuern_gewerblich                        
    ## Steuern_privat                            
    ## Kosten_Basis                              
    ## Kosten_Sortierung                         
    ## Kosten_sonstiges                          
    ## Gebuehrenregelung_STANDARD                
    ## Region_PAYT_Nein            0.186         
    ## 
    ##                Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
    ## SS loadings      5.235   4.281   3.233   1.638   1.336   1.319   1.072   0.738
    ## Proportion Var   0.169   0.138   0.104   0.053   0.043   0.043   0.035   0.024
    ## Cumulative Var   0.169   0.307   0.411   0.464   0.507   0.550   0.584   0.608
    ## 
    ## Test of the hypothesis that 8 factors are sufficient.
    ## The chi square statistic is 32134.73 on 245 degrees of freedom.
    ## The p-value is 0 
    ## [enter] to show next rotation result
    ## Factor Analysis results. Rotation method:  equamax
    ## Call:
    ## factanal(x = ., factors = n_PCs, rotation = rm, lower = 0.1)
    ## 
    ## Uniquenesses:
    ##                    Flaeche               Bevoelkerung 
    ##                      0.368                      0.100 
    ##        Bevoelkerungsdichte              Inselgemeinde 
    ##                      0.108                      0.969 
    ##            Kuestengemeinde         Urbanisierungsgrad 
    ##                      0.705                      0.319 
    ##     Geologischer_Indikator            Abfaelle_gesamt 
    ##                      0.151                      0.100 
    ##          Abfaelle_sortiert        Abfaelle_unsortiert 
    ##                      0.100                      0.100 
    ##            Sortierungsgrad                   Sort_Bio 
    ##                      0.100                      0.100 
    ##                Sort_Papier                  Sort_Glas 
    ##                      0.587                      0.709 
    ##                  Sort_Holz                Sort_Metall 
    ##                      0.481                      0.644 
    ##               Sort_Plastik              Sort_Elektrik 
    ##                      0.680                      0.779 
    ##                Sort_Textil                  Sort_Rest 
    ##                      0.922                      0.581 
    ##         Verwendung_Energie         Verwendung_Deponie 
    ##                      0.100                      0.100 
    ##       Verwendung_Recycling       Verwendung_Unbekannt 
    ##                      0.285                      0.100 
    ##         Steuern_gewerblich             Steuern_privat 
    ##                      0.575                      0.289 
    ##               Kosten_Basis          Kosten_Sortierung 
    ##                      0.100                      0.698 
    ##           Kosten_sonstiges Gebuehrenregelung_STANDARD 
    ##                      0.460                      0.841 
    ##           Region_PAYT_Nein 
    ##                      0.238 
    ## 
    ## Loadings:
    ##                            Factor1 Factor2 Factor3 Factor4 Factor5 Factor6
    ## Flaeche                     0.445          -0.155   0.213   0.114  -0.586 
    ## Bevoelkerung                0.914          -0.218                   0.244 
    ## Bevoelkerungsdichte         0.395                  -0.128           0.844 
    ## Inselgemeinde                                               0.168         
    ## Kuestengemeinde             0.168  -0.195           0.296   0.322   0.151 
    ## Urbanisierungsgrad         -0.550                                  -0.602 
    ## Geologischer_Indikator              0.825          -0.330  -0.125         
    ## Abfaelle_gesamt             0.920          -0.229                   0.215 
    ## Abfaelle_sortiert           0.914   0.109  -0.168                   0.226 
    ## Abfaelle_unsortiert         0.820          -0.324           0.163   0.185 
    ## Sortierungsgrad            -0.212   0.146   0.786  -0.107  -0.195         
    ## Sort_Bio                   -0.300           0.888          -0.129         
    ## Sort_Papier                 0.228   0.205   0.161   0.204  -0.183         
    ## Sort_Glas                  -0.253  -0.171   0.152                  -0.106 
    ## Sort_Holz                   0.165   0.558   0.101  -0.212           0.173 
    ## Sort_Metall                         0.311   0.156  -0.153  -0.102         
    ## Sort_Plastik                       -0.225   0.291                         
    ## Sort_Elektrik                       0.166   0.145                         
    ## Sort_Textil                                 0.129          -0.115         
    ## Sort_Rest                           0.340   0.115  -0.341           0.171 
    ## Verwendung_Energie                  0.205          -0.893  -0.122   0.146 
    ## Verwendung_Deponie                 -0.314  -0.173   0.584          -0.143 
    ## Verwendung_Recycling       -0.129   0.249   0.615          -0.117         
    ## Verwendung_Unbekannt                       -0.253   0.222                 
    ## Steuern_gewerblich         -0.230  -0.319           0.113   0.340  -0.291 
    ## Steuern_privat              0.159   0.770   0.107  -0.182           0.155 
    ## Kosten_Basis                0.116          -0.135   0.119   0.918         
    ## Kosten_Sortierung           0.208  -0.112   0.193           0.421         
    ## Kosten_sonstiges           -0.144          -0.318           0.570         
    ## Gebuehrenregelung_STANDARD -0.103  -0.300  -0.139           0.126   0.101 
    ## Region_PAYT_Nein                   -0.728           0.435   0.179         
    ##                            Factor7 Factor8
    ## Flaeche                                   
    ## Bevoelkerung                              
    ## Bevoelkerungsdichte                       
    ## Inselgemeinde                             
    ## Kuestengemeinde            -0.109         
    ## Urbanisierungsgrad                        
    ## Geologischer_Indikator      0.149         
    ## Abfaelle_gesamt                           
    ## Abfaelle_sortiert                         
    ## Abfaelle_unsortiert        -0.228         
    ## Sortierungsgrad             0.403   0.191 
    ## Sort_Bio                            0.143 
    ## Sort_Papier                 0.416   0.206 
    ## Sort_Glas                   0.380         
    ## Sort_Holz                   0.261   0.138 
    ## Sort_Metall                 0.440         
    ## Sort_Plastik                0.422         
    ## Sort_Elektrik               0.400         
    ## Sort_Textil                 0.186         
    ## Sort_Rest                   0.342   0.126 
    ## Verwendung_Energie                  0.189 
    ## Verwendung_Deponie         -0.198   0.617 
    ## Verwendung_Recycling        0.479         
    ## Verwendung_Unbekannt       -0.105  -0.880 
    ## Steuern_gewerblich                 -0.231 
    ## Steuern_privat              0.111         
    ## Kosten_Basis                              
    ## Kosten_Sortierung           0.165         
    ## Kosten_sonstiges           -0.242  -0.117 
    ## Gebuehrenregelung_STANDARD -0.111         
    ## Region_PAYT_Nein                          
    ## 
    ##                Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
    ## SS loadings      4.364   2.982   2.565   1.981   1.903   1.900   1.725   1.432
    ## Proportion Var   0.141   0.096   0.083   0.064   0.061   0.061   0.056   0.046
    ## Cumulative Var   0.141   0.237   0.320   0.384   0.445   0.506   0.562   0.608
    ## 
    ## Test of the hypothesis that 8 factors are sufficient.
    ## The chi square statistic is 32134.73 on 245 degrees of freedom.
    ## The p-value is 0 
    ## [enter] to show next rotation result
    ## Factor Analysis results. Rotation method:  oblimin
    ## Call:
    ## factanal(x = ., factors = n_PCs, rotation = rm, lower = 0.1)
    ## 
    ## Uniquenesses:
    ##                    Flaeche               Bevoelkerung 
    ##                      0.368                      0.100 
    ##        Bevoelkerungsdichte              Inselgemeinde 
    ##                      0.108                      0.969 
    ##            Kuestengemeinde         Urbanisierungsgrad 
    ##                      0.705                      0.319 
    ##     Geologischer_Indikator            Abfaelle_gesamt 
    ##                      0.151                      0.100 
    ##          Abfaelle_sortiert        Abfaelle_unsortiert 
    ##                      0.100                      0.100 
    ##            Sortierungsgrad                   Sort_Bio 
    ##                      0.100                      0.100 
    ##                Sort_Papier                  Sort_Glas 
    ##                      0.587                      0.709 
    ##                  Sort_Holz                Sort_Metall 
    ##                      0.481                      0.644 
    ##               Sort_Plastik              Sort_Elektrik 
    ##                      0.680                      0.779 
    ##                Sort_Textil                  Sort_Rest 
    ##                      0.922                      0.581 
    ##         Verwendung_Energie         Verwendung_Deponie 
    ##                      0.100                      0.100 
    ##       Verwendung_Recycling       Verwendung_Unbekannt 
    ##                      0.285                      0.100 
    ##         Steuern_gewerblich             Steuern_privat 
    ##                      0.575                      0.289 
    ##               Kosten_Basis          Kosten_Sortierung 
    ##                      0.100                      0.698 
    ##           Kosten_sonstiges Gebuehrenregelung_STANDARD 
    ##                      0.460                      0.841 
    ##           Region_PAYT_Nein 
    ##                      0.238 
    ## 
    ## Loadings:
    ##                            Factor1 Factor2 Factor3 Factor4 Factor5 Factor6
    ## Flaeche                     0.501                                  -0.688 
    ## Bevoelkerung                0.944                                         
    ## Bevoelkerungsdichte         0.367                                   0.770 
    ## Inselgemeinde                                       0.176                 
    ## Kuestengemeinde             0.146  -0.152           0.302           0.180 
    ## Urbanisierungsgrad         -0.538                                  -0.490 
    ## Geologischer_Indikator     -0.128   0.886                                 
    ## Abfaelle_gesamt             0.940                                         
    ## Abfaelle_sortiert           0.936                                         
    ## Abfaelle_unsortiert         0.833          -0.115   0.102  -0.185         
    ## Sortierungsgrad                     0.104   0.690           0.292         
    ## Sort_Bio                   -0.102           0.962          -0.139         
    ## Sort_Papier                 0.191   0.228          -0.159   0.400         
    ## Sort_Glas                  -0.249  -0.234                   0.423         
    ## Sort_Holz                   0.111   0.587                   0.189         
    ## Sort_Metall                -0.120   0.305                   0.415         
    ## Sort_Plastik                       -0.298   0.190           0.464         
    ## Sort_Elektrik                       0.159                   0.399         
    ## Sort_Textil                                        -0.114   0.190         
    ## Sort_Rest                  -0.108   0.320                   0.312   0.149 
    ## Verwendung_Energie                                                        
    ## Verwendung_Deponie                 -0.192  -0.137          -0.135         
    ## Verwendung_Recycling                0.222   0.487           0.392         
    ## Verwendung_Unbekannt                       -0.174                         
    ## Steuern_gewerblich         -0.230  -0.320           0.302   0.113  -0.193 
    ## Steuern_privat              0.114   0.833                                 
    ## Kosten_Basis                                        0.953                 
    ## Kosten_Sortierung           0.246  -0.123   0.261   0.446   0.204         
    ## Kosten_sonstiges           -0.232          -0.237   0.564  -0.177         
    ## Gebuehrenregelung_STANDARD -0.123  -0.312  -0.125                   0.162 
    ## Region_PAYT_Nein                   -0.752                           0.105 
    ##                            Factor7 Factor8
    ## Flaeche                                   
    ## Bevoelkerung                              
    ## Bevoelkerungsdichte                       
    ## Inselgemeinde                             
    ## Kuestengemeinde             0.229         
    ## Urbanisierungsgrad                        
    ## Geologischer_Indikator                    
    ## Abfaelle_gesamt                           
    ## Abfaelle_sortiert                         
    ## Abfaelle_unsortiert                       
    ## Sortierungsgrad                           
    ## Sort_Bio                                  
    ## Sort_Papier                 0.297   0.207 
    ## Sort_Glas                          -0.105 
    ## Sort_Holz                           0.128 
    ## Sort_Metall                               
    ## Sort_Plastik                              
    ## Sort_Elektrik                             
    ## Sort_Textil                               
    ## Sort_Rest                  -0.215         
    ## Verwendung_Energie         -0.900         
    ## Verwendung_Deponie          0.412   0.712 
    ## Verwendung_Recycling                      
    ## Verwendung_Unbekannt        0.314  -0.820 
    ## Steuern_gewerblich                 -0.210 
    ## Steuern_privat                            
    ## Kosten_Basis                              
    ## Kosten_Sortierung                         
    ## Kosten_sonstiges                          
    ## Gebuehrenregelung_STANDARD                
    ## Region_PAYT_Nein            0.233         
    ## 
    ##                Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
    ## SS loadings      4.437   3.168   1.912   1.737   1.482   1.479   1.355   1.336
    ## Proportion Var   0.143   0.102   0.062   0.056   0.048   0.048   0.044   0.043
    ## Cumulative Var   0.143   0.245   0.307   0.363   0.411   0.459   0.502   0.545
    ## 
    ## Factor Correlations:
    ##         Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
    ## Factor1  1.0000 -0.0939 -0.0400 -0.3638  0.1247  0.2537  0.0965  0.0473
    ## Factor2 -0.0939  1.0000 -0.1084 -0.1580  0.2708 -0.1824  0.4422  0.2628
    ## Factor3 -0.0400 -0.1084  1.0000 -0.1607  0.0982  0.0407 -0.0091  0.0420
    ## Factor4 -0.3638 -0.1580 -0.1607  1.0000 -0.2933  0.0623 -0.1330 -0.4443
    ## Factor5  0.1247  0.2708  0.0982 -0.2933  1.0000 -0.1450  0.2261  0.1925
    ## Factor6  0.2537 -0.1824  0.0407  0.0623 -0.1450  1.0000 -0.2260 -0.0404
    ## Factor7  0.0965  0.4422 -0.0091 -0.1330  0.2261 -0.2260  1.0000  0.1175
    ## Factor8  0.0473  0.2628  0.0420 -0.4443  0.1925 -0.0404  0.1175  1.0000
    ## 
    ## Test of the hypothesis that 8 factors are sufficient.
    ## The chi square statistic is 32134.73 on 245 degrees of freedom.
    ## The p-value is 0 
    ## [enter] to show next rotation result
    ## Factor Analysis results. Rotation method:  oblimax
    ## Call:
    ## factanal(x = ., factors = n_PCs, rotation = rm, lower = 0.1)
    ## 
    ## Uniquenesses:
    ##                    Flaeche               Bevoelkerung 
    ##                      0.368                      0.100 
    ##        Bevoelkerungsdichte              Inselgemeinde 
    ##                      0.108                      0.969 
    ##            Kuestengemeinde         Urbanisierungsgrad 
    ##                      0.705                      0.319 
    ##     Geologischer_Indikator            Abfaelle_gesamt 
    ##                      0.151                      0.100 
    ##          Abfaelle_sortiert        Abfaelle_unsortiert 
    ##                      0.100                      0.100 
    ##            Sortierungsgrad                   Sort_Bio 
    ##                      0.100                      0.100 
    ##                Sort_Papier                  Sort_Glas 
    ##                      0.587                      0.709 
    ##                  Sort_Holz                Sort_Metall 
    ##                      0.481                      0.644 
    ##               Sort_Plastik              Sort_Elektrik 
    ##                      0.680                      0.779 
    ##                Sort_Textil                  Sort_Rest 
    ##                      0.922                      0.581 
    ##         Verwendung_Energie         Verwendung_Deponie 
    ##                      0.100                      0.100 
    ##       Verwendung_Recycling       Verwendung_Unbekannt 
    ##                      0.285                      0.100 
    ##         Steuern_gewerblich             Steuern_privat 
    ##                      0.575                      0.289 
    ##               Kosten_Basis          Kosten_Sortierung 
    ##                      0.100                      0.698 
    ##           Kosten_sonstiges Gebuehrenregelung_STANDARD 
    ##                      0.460                      0.841 
    ##           Region_PAYT_Nein 
    ##                      0.238 
    ## 
    ## Loadings:
    ##                            Factor1      Factor2      Factor3      Factor4     
    ## Flaeche                     9765913.005  9765912.325        0.839       -0.723
    ## Bevoelkerung                 249550.835   249550.932        0.758             
    ## Bevoelkerungsdichte        -9967147.724 -9967146.900       -0.136        0.859
    ## Inselgemeinde               -682826.376  -682826.253                          
    ## Kuestengemeinde            -2331264.085 -2331263.377                     0.249
    ## Urbanisierungsgrad          6049376.485  6049375.954       -0.173       -0.533
    ## Geologischer_Indikator       -88870.116   -88871.180        0.476       -0.272
    ## Abfaelle_gesamt              755963.085   755963.043        0.844             
    ## Abfaelle_sortiert            645541.184   645541.074        0.850             
    ## Abfaelle_unsortiert          637814.350   637814.462        0.725       -0.115
    ## Sortierungsgrad             -329776.654  -329777.094       -0.148        0.451
    ## Sort_Bio                     213499.925   213499.652       -0.322        0.430
    ## Sort_Papier                  179924.784   179924.709        0.397        0.301
    ## Sort_Glas                    145235.961   145235.910       -0.338             
    ## Sort_Holz                   -957381.475  -957382.066        0.463        0.152
    ## Sort_Metall                  407835.483   407834.941        0.159             
    ## Sort_Plastik                 161340.603   161340.679       -0.142        0.180
    ## Sort_Elektrik               1255948.197  1255947.816        0.182             
    ## Sort_Textil                 -411840.600  -411840.560                     0.164
    ## Sort_Rest                  -1961570.546 -1961570.969                     0.215
    ## Verwendung_Energie          -137322.957  -137323.812                          
    ## Verwendung_Deponie          1041159.869  1041160.826                     0.708
    ## Verwendung_Recycling        -661525.815  -661526.290                     0.260
    ## Verwendung_Unbekannt        -248017.156  -248017.133                    -1.011
    ## Steuern_gewerblich          2197612.537  2197612.665       -0.285       -0.437
    ## Steuern_privat              -492833.259  -492834.117        0.616       -0.163
    ## Kosten_Basis                 222461.664   222461.923        0.129       -0.138
    ## Kosten_Sortierung            755074.498   755074.524        0.133             
    ## Kosten_sonstiges            -244088.190  -244087.870       -0.129       -0.241
    ## Gebuehrenregelung_STANDARD -2349452.594 -2349451.998       -0.391        0.189
    ## Region_PAYT_Nein           -1729960.931 -1729959.739       -0.562        0.259
    ##                            Factor5      Factor6      Factor7      Factor8     
    ## Flaeche                          -0.551       -0.435        0.282             
    ## Bevoelkerung                                   0.273        0.485       -0.103
    ## Bevoelkerungsdichte               0.558        0.653        0.151             
    ## Inselgemeinde                                                            0.162
    ## Kuestengemeinde                   0.296        0.177                     0.274
    ## Urbanisierungsgrad               -0.318       -0.504       -0.258             
    ## Geologischer_Indikator           -0.122       -0.215       -0.116             
    ## Abfaelle_gesamt                                0.209        0.508             
    ## Abfaelle_sortiert                              0.267        0.501             
    ## Abfaelle_unsortiert              -0.105                     0.454             
    ## Sortierungsgrad                   0.323                                       
    ## Sort_Bio                          0.380       -0.448                          
    ## Sort_Papier                       0.164        0.283       -0.155             
    ## Sort_Glas                         0.116        0.261                          
    ## Sort_Holz                                                                     
    ## Sort_Metall                                    0.166       -0.101             
    ## Sort_Plastik                      0.228        0.328                          
    ## Sort_Elektrik                                  0.158                          
    ## Sort_Textil                       0.123        0.172                          
    ## Sort_Rest                                      0.236                          
    ## Verwendung_Energie               -0.701                     0.433             
    ## Verwendung_Deponie               -0.222                    -0.366        0.109
    ## Verwendung_Recycling              0.348                                       
    ## Verwendung_Unbekannt              0.593                                 -0.110
    ## Steuern_gewerblich                                                       0.261
    ## Steuern_privat                                -0.167                          
    ## Kosten_Basis                                                0.182        0.854
    ## Kosten_Sortierung                 0.135        0.105        0.268        0.422
    ## Kosten_sonstiges                 -0.123                                  0.477
    ## Gebuehrenregelung_STANDARD                     0.185                          
    ## Region_PAYT_Nein                  0.401        0.330                          
    ## 
    ##                     Factor1      Factor2      Factor3      Factor4      Factor5
    ## SS loadings    2.614561e+14 2.614560e+14 5.194000e+00 4.306000e+00 2.423000e+00
    ## Proportion Var 8.434067e+12 8.434066e+12 1.680000e-01 1.390000e-01 7.800000e-02
    ## Cumulative Var 8.434067e+12 1.686813e+13 1.686813e+13 1.686813e+13 1.686813e+13
    ##                     Factor6      Factor7      Factor8
    ## SS loadings    1.956000e+00 1.624000e+00 1.386000e+00
    ## Proportion Var 6.300000e-02 5.200000e-02 4.500000e-02
    ## Cumulative Var 1.686813e+13 1.686813e+13 1.686813e+13
    ## 
    ## Factor Correlations:
    ##         Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
    ## Factor1  1.0000  1.0000  0.4717 -0.3044 -0.0397  0.2550  0.3670  0.3658
    ## Factor2  1.0000  1.0000  0.4717 -0.3044 -0.0397  0.2550  0.3670  0.3658
    ## Factor3  0.4717  0.4717  1.0000 -0.4037  0.0792  0.0161  0.2106  0.2073
    ## Factor4 -0.3044 -0.3044 -0.4037  1.0000  0.0726 -0.0222 -0.1885 -0.2095
    ## Factor5 -0.0397 -0.0397  0.0792  0.0726  1.0000 -0.1266 -0.0847 -0.0469
    ## Factor6  0.2550  0.2550  0.0161 -0.0222 -0.1266  1.0000  0.0957  0.0646
    ## Factor7  0.3670  0.3670  0.2106 -0.1885 -0.0847  0.0957  1.0000  0.1663
    ## Factor8  0.3658  0.3658  0.2073 -0.2095 -0.0469  0.0646  0.1663  1.0000
    ## 
    ## Test of the hypothesis that 8 factors are sufficient.
    ## The chi square statistic is 32134.73 on 245 degrees of freedom.
    ## The p-value is 0 
    ## [enter] to show next rotation result
    ## Factor Analysis results. Rotation method:  promax
    ## Call:
    ## factanal(x = ., factors = n_PCs, rotation = rm, lower = 0.1)
    ## 
    ## Uniquenesses:
    ##                    Flaeche               Bevoelkerung 
    ##                      0.368                      0.100 
    ##        Bevoelkerungsdichte              Inselgemeinde 
    ##                      0.108                      0.969 
    ##            Kuestengemeinde         Urbanisierungsgrad 
    ##                      0.705                      0.319 
    ##     Geologischer_Indikator            Abfaelle_gesamt 
    ##                      0.151                      0.100 
    ##          Abfaelle_sortiert        Abfaelle_unsortiert 
    ##                      0.100                      0.100 
    ##            Sortierungsgrad                   Sort_Bio 
    ##                      0.100                      0.100 
    ##                Sort_Papier                  Sort_Glas 
    ##                      0.587                      0.709 
    ##                  Sort_Holz                Sort_Metall 
    ##                      0.481                      0.644 
    ##               Sort_Plastik              Sort_Elektrik 
    ##                      0.680                      0.779 
    ##                Sort_Textil                  Sort_Rest 
    ##                      0.922                      0.581 
    ##         Verwendung_Energie         Verwendung_Deponie 
    ##                      0.100                      0.100 
    ##       Verwendung_Recycling       Verwendung_Unbekannt 
    ##                      0.285                      0.100 
    ##         Steuern_gewerblich             Steuern_privat 
    ##                      0.575                      0.289 
    ##               Kosten_Basis          Kosten_Sortierung 
    ##                      0.100                      0.698 
    ##           Kosten_sonstiges Gebuehrenregelung_STANDARD 
    ##                      0.460                      0.841 
    ##           Region_PAYT_Nein 
    ##                      0.238 
    ## 
    ## Loadings:
    ##                            Factor1 Factor2 Factor3 Factor4 Factor5 Factor6
    ## Flaeche                     0.436                                         
    ## Bevoelkerung                1.004          -0.106                         
    ## Bevoelkerungsdichte         0.474                                         
    ## Inselgemeinde                                       0.182                 
    ## Kuestengemeinde             0.149          -0.159   0.282           0.231 
    ## Urbanisierungsgrad         -0.627                                         
    ## Geologischer_Indikator     -0.162           0.966          -0.103         
    ## Abfaelle_gesamt             0.993                                         
    ## Abfaelle_sortiert           0.995                                         
    ## Abfaelle_unsortiert         0.871  -0.259                                 
    ## Sortierungsgrad            -0.127   0.876                   0.101         
    ## Sort_Bio                   -0.176   0.690                                 
    ## Sort_Papier                 0.168   0.472   0.136           0.130   0.326 
    ## Sort_Glas                  -0.208   0.399  -0.275                         
    ## Sort_Holz                   0.107   0.171   0.584           0.117         
    ## Sort_Metall                -0.111   0.371   0.288                         
    ## Sort_Plastik                0.104   0.628  -0.370                         
    ## Sort_Elektrik                       0.393   0.129                         
    ## Sort_Textil                 0.114   0.276  -0.124                         
    ## Sort_Rest                           0.230   0.301           0.130  -0.190 
    ## Verwendung_Energie          0.126  -0.157   0.114           0.271  -0.947 
    ## Verwendung_Deponie         -0.123  -0.192  -0.308           0.644   0.402 
    ## Verwendung_Recycling                0.794   0.201                         
    ## Verwendung_Unbekannt               -0.211                  -0.925   0.344 
    ## Steuern_gewerblich         -0.221          -0.279   0.274  -0.183         
    ## Steuern_privat                              0.900          -0.124   0.130 
    ## Kosten_Basis                                0.114   0.970                 
    ## Kosten_Sortierung           0.267   0.379  -0.111   0.472                 
    ## Kosten_sonstiges           -0.238  -0.447           0.540                 
    ## Gebuehrenregelung_STANDARD         -0.160  -0.326                         
    ## Region_PAYT_Nein                    0.113  -0.820                   0.214 
    ##                            Factor7 Factor8
    ## Flaeche                     0.750         
    ## Bevoelkerung                              
    ## Bevoelkerungsdichte        -0.719         
    ## Inselgemeinde                             
    ## Kuestengemeinde            -0.161         
    ## Urbanisierungsgrad          0.421         
    ## Geologischer_Indikator                    
    ## Abfaelle_gesamt             0.104         
    ## Abfaelle_sortiert                         
    ## Abfaelle_unsortiert                       
    ## Sortierungsgrad                     0.415 
    ## Sort_Bio                            0.737 
    ## Sort_Papier                               
    ## Sort_Glas                          -0.124 
    ## Sort_Holz                                 
    ## Sort_Metall                        -0.135 
    ## Sort_Plastik                              
    ## Sort_Elektrik                      -0.104 
    ## Sort_Textil                               
    ## Sort_Rest                  -0.154  -0.133 
    ## Verwendung_Energie                        
    ## Verwendung_Deponie                        
    ## Verwendung_Recycling                0.240 
    ## Verwendung_Unbekannt                      
    ## Steuern_gewerblich          0.150         
    ## Steuern_privat                            
    ## Kosten_Basis                              
    ## Kosten_Sortierung                   0.139 
    ## Kosten_sonstiges                   -0.123 
    ## Gebuehrenregelung_STANDARD -0.179         
    ## Region_PAYT_Nein           -0.124         
    ## 
    ##                Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
    ## SS loadings      5.009   3.676   3.613   1.719   1.487   1.465   1.447   0.918
    ## Proportion Var   0.162   0.119   0.117   0.055   0.048   0.047   0.047   0.030
    ## Cumulative Var   0.162   0.280   0.397   0.452   0.500   0.547   0.594   0.624
    ## 
    ## Factor Correlations:
    ##         Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
    ## Factor1  1.0000  -0.144 -0.1568  0.2407  0.0574  0.2418  0.1896  0.1987
    ## Factor2 -0.1443   1.000  0.1096  0.4444  0.4006 -0.2776 -0.1855  0.3961
    ## Factor3 -0.1568   0.110  1.0000 -0.1541  0.2550 -0.0746  0.0913  0.1031
    ## Factor4  0.2407   0.444 -0.1541  1.0000  0.2611 -0.2896 -0.0699  0.3070
    ## Factor5  0.0574   0.401  0.2550  0.2611  1.0000 -0.2139  0.0155  0.2898
    ## Factor6  0.2418  -0.278 -0.0746 -0.2896 -0.2139  1.0000 -0.1025 -0.0979
    ## Factor7  0.1896  -0.186  0.0913 -0.0699  0.0155 -0.1025  1.0000 -0.2323
    ## Factor8  0.1987   0.396  0.1031  0.3070  0.2898 -0.0979 -0.2323  1.0000
    ## 
    ## Test of the hypothesis that 8 factors are sufficient.
    ## The chi square statistic is 32134.73 on 245 degrees of freedom.
    ## The p-value is 0

62.3 % is the maximum amount of cumulative variance with 7 factors.
Approximately 20 % less than what the PCA yielded. Therefore PCA will be
used.

## Cluster Analysis

To assess the clustering tendency of a data set the *Hopkins Statistic*
can be used. It measures the probability that a given data set was
generated by a uniform data distribution. The higher the resulting value
the better the clustering tendency. Values range from 0 to 1.

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

The combination of *canberra* and *ward.D2* looks most promising.

``` r
hclust_a <- 
  dist(scale(wm_df_transformed_pca), 
       method = "canberra") %>% 
  hclust(method = "ward.D2")

ggdendrogram(hclust_a, leaf_labels = F, labels = F) +
  labs(title = paste0("Distance: Canberra", "\nCluster: ward.D2"))
```

![](Exploratory_Data_Analysis_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

4 or maybe for clusters seem to be viable options. Microsoft Excel can
be used to comfortably compare clusters for profiling and help
determining the number of clusters to choose.

*EXCEL SCREENSHOT OR STH*
