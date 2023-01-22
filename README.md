# Derivation of Waste Management Profiles (*WIP*)

## Todos:
- [ ] references: ~bartlett test~, ~kmo~, pca, fa
- [ ] clustering: diana, mona, agnes, k-means
- [ ] profiling
- [ ] output code

## Context
Although only about 15% of all waste within the EU is generated as municipal waste[^bignote], the absolute figures pose a major problem for municipalities, waste management companies and the environment. 225.7 million tonnes of municipal waste were collected in the EU in 2020, of which only 68 million tonnes were directly recycled, with the remainder going into long-term landfill or being incinerated for energy generation. In view of the climate-damaging landfill gases produced during storage or CO2 emissions during incineration, combined with the problem of the large amount of space required, the EU's goal is to constantly optimise its waste management. This is intended to promote the production of less waste, a stronger circular economy and the economic efficiency of waste management.
In the context of this optimisation, we want to work out a status quo of municipal waste management in Italian municipalities, on which subsequent optimisation projects can build. For this purpose, we base our work on a data set on the waste management of a total of 4341 Italian municipalities. With the help of these data, we are to draw up profiles of the municipalities, which we can cluster them with regard to their descriptive characteristics, in particular the key figures of waste management, but also geographical and economic factors.

<details>
  <summary>(<i>click to show/hide the characteristics of the data set</i>)</summary>
  <!-- have to be followed by an empty line! -->

|	ID	|	Column name	|	Explanation	|
|:---|:---|:---|
|	1	|	ID	|	Unique identification number of the municipality.	|
|	2	|	Region	|	Region in which the municipality is located.	|
|	3	|	Provinz	|	Province in which the municipality is located.	|
|	4	|	Gemeinde	|	Name of the municipality.	|
|	5	|	Flaeche	|	Area of the municipality in km².	|
|	6	|	Bevoelkerung	|	Population of the municipality.	|
|	7	|	Bevoelkerungsdichte	|	Population of the municipality per km².	|
|	8	|	Strassen	|	Total length of all roads in the municipality in km.	|
|	9	|	Invelgemeinde	|	Indicator whether municipality is on an island (1 yes, 0 no).	|
|	10	|	Kuestengemeinde	|	Indicator whether municipality is on the coast (1 yes, 0 no).	|
|	11	|	Urbanisierungsgrad	|	Degree of municipality urbanisation (1 low, 3 high).	|
|	12	|	Geologischer_Indikator  |	Geological location of the municipality (1 south, 2 central, 3 north).	|
|	13	|	Abfaelle_gesamt	|	Total amount of municipal waste in kilotonnes (kt).	|
|	14	|	Abfaelle_sortiert	|	Municipal waste sorted in kilotonnes (kt).	|
|	15	|	Abfaelle_unsortiert	|	Unsorted municipal waste in kilotonnes (kt).	|
|	16	|	Sortierungsgrad	|	Percentage of sorted municipal waste in total.	|
|	17	|	Sort_Bio  | Proportion of organic waste among the sorted.	|
|	18	|	Sort_Papier	|	Proportion of paper waste sorted.	|
|	19	|	Sort_Glas	|	Percentage of glass waste sorted.	|
|	20	|	Sort_Holz	|	Proportion of wood waste among those sorted.	|
|	21	|	Sort_Metall	|	Proportion of metal waste among the sorted.	|
|	22	|	Sort_Plastik	|	Proportion of plastic waste among the sorted.	|
| 23  | Sort_Elektrik | Proportion of electrical waste among those sorted.  |
| 24  | Sort__Textil |  Proportion of textile waste among those sorted. |
| 25  | Sort_Rest | Proportion of residual waste among those sorted.  |
| 26  | Verwendung_Energie |  Proportion of waste that is used for energy recovery. |
| 27  | Verwendung_Deponie |  Proportion of waste that is landfilled. |
| 28  | Verwendung_Recycling |  Proportion of waste that is recycled. |
| 29  | Verwendung_Unbekannt |  Proportion of waste whose further use is unknown. |
| 30  | Steuern_gewerblich |  Per capita Tax revenue from commercial sources. |
| 31  | Steuern_privat |  Per capita tax revenue from private sources.  |
| 32  | Kosten_Basis |  Per capita basic costs of waste management. |
| 33  | Kosten_Sortierung | Per capita sorting costs of waste management companies. |
| 34  | Kosten_sonstiges |  Per capita other costs of waste management.  |
| 35  | Gebuehrenregelung | Waste fee regulation of the municipality. |
| 36  | Region_PAYT | Indicator whether region offers PAYT (pay as you throw).  |
</details>


[^bignote]: Municipal waste is all waste collected and treated by or for municipalities. It includes waste from households
including bulky waste, similar waste from trade and commerce, office buildings, institutions and small businesses, as well as yard and garden waste, street sweepings and the contents of waste containers.
yard and garden waste, street sweepings and the contents of waste containers. The definition includes waste from municipal
sewage networks and their treatment as well as waste from construction and demolition work.

## Exploratory Data Analysis
Get an overview of the data set.
```r
wm_df <- load2("data/waste_management.RData")
skimr::skim(wm_df)
#wm_df %>% complete.cases() %>% sum()
```
<details>
  <summary>(<i>click to show/hide console output</i>)</summary>
  <!-- have to be followed by an empty line! -->

```
── Data Summary ────────────────────────
                           Values
Name                       wm_df 
Number of rows             4341  
Number of columns          36    
_______________________          
Column type frequency:           
  character                5     
  numeric                  31    
________________________         
Group variables            None  
── Variable type: character ────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable     n_missing complete_rate min max empty n_unique whitespace
1 Region                    0         1       5  21     0       20          0
2 Provinz                   0         1       4  21     0      102          0
3 Gemeinde                  6         0.999   2  60     0     4333          0
4 Gebuehrenregelung         0         1       4   8     0        2          0
5 Region_PAYT               0         1       2   4     0        2          0

── Variable type: numeric ──────────────────────────────────────────────────────────────────────────────────────────────────────
   skim_variable          n_missing complete_rate        mean         sd      p0      p25      p50      p75      p100 hist 
 1 ID                             0         1     47470.      30090.     1272    18135    42015    70049     111107   ▇▃▅▃▃
 2 Flaeche                        6         0.999    41.0        56.8       0.12    10.8     22.7     47.5     1287.  ▇▁▁▁▁
 3 Bevoelkerung                   0         1     10204.      53426.       34     1579     3535     8199    2617175   ▇▁▁▁▁
 4 Bevoelkerungsdichte            6         0.999   405.        771.        2.48    62.6    151.     399.     12123.  ▇▁▁▁▁
 5 Strassen                     443         0.898   102.        310.        1       25       51      105      14970   ▇▁▁▁▁
 6 Inselgemeinde                  6         0.999     0.00507     0.0711    0        0        0        0          1   ▇▁▁▁▁
 7 Kuestengemeinde                6         0.999     0.168       0.374     0        0        0        0          1   ▇▁▁▁▂
 8 Urbanisierungsgrad             6         0.999     2.49        0.595     1        2        3        3          3   ▁▁▆▁▇
 9 Geologischer_Indikator       285         0.934     2.29        0.888     1        1        3        3          3   ▃▁▂▁▇
10 Abfaelle_gesamt                0         1         5.31       32.5       0.02     0.61     1.52     3.95    1692.  ▇▁▁▁▁
11 Abfaelle_sortiert              0         1         3.25       15.6       0        0.37     1.04     2.73     765.  ▇▁▁▁▁
12 Abfaelle_unsortiert            0         1         2.04       17.6       0.01     0.18     0.41     1.06     927.  ▇▁▁▁▁
13 Sortierungsgrad                0         1        60.1        19.8       0       44.3     64.3     76.5       97.5 ▁▃▅▇▅
14 Sort_Bio                     511         0.882    22.3        12.7       0.01    11.1     25.0     31.8       61.6 ▅▅▇▂▁
15 Sort_Papier                   25         0.994    11.0         3.88      0        8.66    10.9     13.1       45.3 ▃▇▁▁▁
16 Sort_Glas                     33         0.992     9.41        3.71      0        7.15     9.1     11.3       39.8 ▅▇▁▁▁
17 Sort_Holz                   1095         0.748     4.11        2.72      0        2.08     4.02     5.71      25.1 ▇▃▁▁▁
18 Sort_Metall                  246         0.943     1.76        1.35      0        0.88     1.54     2.35      20.7 ▇▁▁▁▁
19 Sort_Plastik                  39         0.991     6.11        3.26      0        4.13     5.79     7.55      31.6 ▇▆▁▁▁
20 Sort_Elektrik                314         0.928     1.23        0.821     0        0.78     1.18     1.57      18.0 ▇▁▁▁▁
21 Sort_Textil                 1013         0.767     0.757       0.688     0        0.35     0.63     0.99      10.6 ▇▁▁▁▁
22 Sort_Rest                    136         0.969     7.94        5.15      0.03     3.96     7.13    11.1       37.2 ▇▆▂▁▁
23 Verwendung_Energie             0         1        20.3        15.7       0        5.63    18.5     38.5       55.1 ▇▃▂▇▁
24 Verwendung_Deponie             0         1        17.9        19.5       0        4.55    11.3     31.5       76.7 ▇▁▂▁▁
25 Verwendung_Recycling           0         1        41.3        12.8       2.35    32.7     43.2     51.6       76.7 ▁▅▇▇▁
26 Verwendung_Unbekannt           0         1        20.5        17.8       0        5.21    17.8     31.0       97.4 ▇▅▂▁▁
27 Steuern_gewerblich           386         0.911 16565.      14132.     4180.    9080.   12465.   19413.    377492.  ▇▁▁▁▁
28 Steuern_privat               285         0.934 13211.       3649.     2606.   10162.   13668.   15759.     35770.  ▂▇▃▁▁
29 Kosten_Basis                   0         1       154.         76.1      25.7    108.     137.     179.       977.  ▇▁▁▁▁
30 Kosten_Sortierung             67         0.985    52.7        33.1       3.39    31.3     48.9     66.4      582.  ▇▁▁▁▁
31 Kosten_sonstiges              52         0.988    54.2        43.2       4.27    27.3     41.7     66.5      670.  ▇▁▁▁▁
```
</details>

There are quite a lot of missing values. Omitting all of them would mean a loss of more than 50 % of the data.
Create some plots to enhance the understanding of the data set:
```r
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

<p align = "center">
  <picture>
    <img src="img/box_waste_reg_outl.svg">
  </picture>
</p>


A lot of outliers in total amounts of waste per community. I am going to take care of them later. Til then they will be hidden, so other values appear less compressed.

```r
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
<p align = "center">
  <picture>
    <img src="img/box_waste_reg.svg">
  </picture>
</p>

```r
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
<p align = "center">
  <picture>
    <img src="img/box_waste_geo.svg">
  </picture>
</p>

```r
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
<p align = "center">
  <picture>
    <img src="img/point_waste_pop_urb.svg">
  </picture>
</p>

```r
wm_df %>% na.omit %>% 
  mutate(Urbanisierungsgrad = ifelse(Urbanisierungsgrad == 1, "Urbanization low",
                                     ifelse(Urbanisierungsgrad == 3, "Urbanization high",
                                            "Urbanization mid"))) %>% 
  ggplot(aes(x=Urbanisierungsgrad, y=Abfaelle_gesamt)) +
  ggtitle("Mean waste by urbanisation degree") +
  stat_summary(aes(group = Urbanisierungsgrad, fill = Urbanisierungsgrad), fun = mean, geom = "bar") +
  labs(y = "mean(Abfaelle_gesamt)") +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        plot.title = element_text(hjust = 0.5))
```
<p align = "center">
  <picture>
    <img src="img/mean_waste_urb.svg">
  </picture>
</p>


Inspecting missing values within the waste sorting related columns:

```r
sapply(wm_df[,16:25],
       function(y) sum(length(which(is.na(y))))) %>%
  tibble(Column = names(.),
         NA_Count = .)
```
<details>
  <summary>(<i>click to show/hide console output</i>)</summary>
  <!-- have to be followed by an empty line! -->

```
# A tibble: 10 × 2
   Column          NA_Count
   <chr>              <int>
 1 Sortierungsgrad        0
 2 Sort_Bio             511
 3 Sort_Papier           25
 4 Sort_Glas             33
 5 Sort_Holz           1095
 6 Sort_Metall          246
 7 Sort_Plastik          39
 8 Sort_Elektrik        314
 9 Sort_Textil         1013
10 Sort_Rest            136
```
</details>

```r
Sort_NAs <- c()
for (i in 17:25) {
  nas_t <- which(is.na(wm_df[i]))
  Sort_NAs <- c(Sort_NAs, nas_t)
}

Sort_NAs_table <- Sort_NAs %>% table %>% sort(decreasing = T)
Sort_NAs_table[1:5] %>% names %>% as.numeric -> t

wm_df[t,16:25]
```
<details>
  <summary>(<i>click to show/hide console output</i>)</summary>
  <!-- have to be followed by an empty line! -->

```
     Sortierungsgrad Sort_Bio Sort_Papier Sort_Glas Sort_Holz Sort_Metall Sort_Plastik Sort_Elektrik Sort_Textil Sort_Rest
429             0.72       NA        0.72        NA        NA          NA           NA            NA          NA        NA
3572            0.70       NA          NA        NA        NA          NA           NA           0.7          NA        NA
4175            0.00       NA          NA        NA        NA          NA           NA           0.0          NA        NA
3777           59.32       NA          NA     39.84        NA          NA           NA            NA          NA     19.48
4017            1.87       NA          NA        NA        NA          NA         0.62            NA          NA      1.25
```
</details>

Looks like the sum of the values present in these waste sorting columns equals
the value in Sortierungsgrad. Imputing any values here would completely destroy the logic behind these columns. I would argue that dropping all these values is a viable option. However, one could also say that replacing these NAs with zeros instead might work out as well. The latter option is the one I chose.

## Dimension Reduction

Within the data set there are dimensions that hold no value when it comes to any analyses. "ID" is a unique identifier, "Gemeinde" the name of a community, "Strassen" contains more than 10 % missing values, "Region" and "Provinz" contain too many unique values that would complicate the process a lot. Also the importance of the information they hold is questionable.

```r
cols_to_exclude <- c("ID", "Gemeinde", "Strassen", "Region", "Provinz")
```

A vector containing the names of the columns mentioned is created.
A recipe from the *tidyverse* is used to remove these dimensions, replace missing values via bag imputation and replace outliers in numeric dimension with the IQR limits of their individual column and replace the remaining nominal columns with dummy variables.

Note: *step_impute_constant()* and *step_outliers_iqr_to_limits()* are functions from the *steffanossaR* package found at https://github.com/steffanossa/steffanossaR.

```r
recipe_prep <- recipe(~., data = wm_df) %>% 
  step_rm(all_of(cols_to_exclude)) %>% 
  step_impute_constant(contains("Sort_"), constant = 0) %>% 
  step_impute_bag(all_numeric()) %>% 
  step_outliers_iqr_to_limits(all_numeric(), -ends_with("gemeinde") %>% 
  step_other(all_nominal(), threshold = .001, other = NA) %>% 
  step_naomit(everything(), skip = T) %>% 
  step_dummy(all_nominal()) %>% 
  step_zv(everything())
```
```r
#| include: false
set.seed(187)
wm_df_prepped <- recipe_prep %>% prep %>% bake(new_data = NULL)
```

### Principal Components Analysis (PCA)

A PCA is used to reduce the number of variables by finding principal components of the data, which are new and uncorrelated variables that can explain the most variance in the original data.

First, the *Bartlett Test* is done.
The Bartlett test verifies the null hypothesis that the correlation matrix is equal to the identity matrix, meaning that the variables of a given data set are uncorrelated. If the resulting value is below .05, the null hypothesis is rejected and it is concluded, that the variables are correlated[^2].

[^2]: Reference: https://www.itl.nist.gov/div898/handbook/eda/section3/eda357.htm

```r
psych::cortest.bartlett(cor(wm_df_prepped), n = 100)$p.value
```
<details>
  <summary>(<i>click to show/hide console output</i>)</summary>
  <!-- have to be followed by an empty line! -->

```
[1] 3.075839e-286
```
</details>

The p-value is way below 0.05, there is correlation between the dimensions of the data set.

Next, the *Kaiser-Mayer-Olkin Criterion* (KMO) is looked at.
The KMO measures the adequacy of a dataset for factor analysis.
It ranges from 0 to 1, where a higher value indicates higher suitability.
A value above .6 is generally considered to be the threshold.
However, some sources also consider .5 to be acceptable[^3].

[^3]: Reference: https://www.empirical-methods.hslu.ch/entscheidbaum/interdependenzanalyse/reduktion-der-variablen/faktoranalyse/
```r
psych::KMO(wm_df_prepped)$MSA
```
<details>
  <summary>(<i>click to show/hide console output</i>)</summary>
  <!-- have to be followed by an empty line! -->

```
[1] 0.568148
```
</details>

~0.57 is not very good but I will consider this acceptable.
Now the PCA can be executed.

```r
wm_df_pca <- 
  wm_df_prepped %>% 
  prcomp(scale. = T,
         center = T)
wm_df_pca %>% summary()
```
<details>
  <summary>(<i>click to show/hide console output</i>)</summary>
  <!-- have to be followed by an empty line! -->

```
Importance of components:
                          PC1      PC2     PC3     PC4     PC5     PC6     PC7     PC8
Standard deviation     2.5701   2.3601  1.5934 1.35156 1.25891 1.15567 1.03789 1.02265
Proportion of Variance 0.2131   0.1797  0.0819 0.05893 0.05112 0.04308 0.03475 0.03374
Cumulative Proportion  0.2131   0.3928  0.4747 0.53359 0.58471 0.62780 0.66255 0.69628
                           PC9    PC10    PC11    PC12    PC13    PC14    PC15    PC16
Standard deviation     0.96964 0.95687 0.91417 0.88252 0.85881 0.80217 0.79484 0.76324
Proportion of Variance 0.03033 0.02954 0.02696 0.02512 0.02379 0.02076 0.02038 0.01879
Cumulative Proportion  0.72661 0.75615 0.78310 0.80823 0.83202 0.85278 0.87316 0.89195
                          PC17    PC18    PC19    PC20    PC21    PC22    PC23    PC24
Standard deviation     0.74113 0.69080 0.64876 0.60780 0.55877  0.5454 0.47311 0.45339
Proportion of Variance 0.01772 0.01539 0.01358 0.01192 0.01007  0.0096 0.00722 0.00663
Cumulative Proportion  0.90967 0.92506 0.93864 0.95055 0.96063  0.9702 0.97744 0.98407
                          PC25    PC26    PC27    PC28    PC29    PC30    PC31
Standard deviation     0.43197 0.38751 0.32419 0.17301 0.09742 0.08771 0.06887
Proportion of Variance 0.00602 0.00484 0.00339 0.00097 0.00031 0.00025 0.00015
Cumulative Proportion  0.99009 0.99494 0.99833 0.99929 0.99960 0.99985 1.00000
```
</details>

Taking a look at the first 15 principal components (PC) and the percentage of variance they explain.

```r
wm_df_pca %>% factoextra::fviz_eig(ncp = 15,
                                   addlabels = T)
```

<p align = "center">
  <picture>
    <img src="img/pca_expl_var.svg">
  </picture>
</p>

The *elbow method* would suggest using three PCs. The cumulative variance of 49.942 % when taking only three is too little to result in useful outcomes.

Another method of evaluating the number of PCs to keep is the *Kaiser Criterion* which states that factors with an eigenvalue above 1 are considered important and should be retained. An eigenvalue above 1 means its factor explains more variance than a single variable would.

```r
factoextra::get_eig(wm_df_pca) %>%
  filter(eigenvalue > 1)
```
<details>
  <summary>(<i>click to show/hide console output</i>)</summary>
  <!-- have to be followed by an empty line! -->

```
      eigenvalue variance.percent cumulative.variance.percent
Dim.1   6.605658        21.308573                    21.30857
Dim.2   5.569971        17.967650                    39.27622
Dim.3   2.538892         8.189973                    47.46620
Dim.4   1.826722         5.892652                    53.35885
Dim.5   1.584867         5.112473                    58.47132
Dim.6   1.335573         4.308301                    62.77962
Dim.7   1.077217         3.474892                    66.25451
Dim.8   1.045812         3.373587                    69.62810
```
</details>

8 factors possess eigenvalues above 1 with a cumulative variance of 69.62810 %.

A third approach is *Horn's Method*.
Here random data sets with equal size (columns and rows) as the original data set are generated and then a factor analysis is performed on each of them. The retained number of factors are then compared. The idea is that if the number of factors kept in the original data set is similar to the number of factors kept in the random sets, the factors of the original data set are considered not meaningful. If the number of factors of the original data set is larger than the number of factors in the random sets, the factors in the original data set are considered meaningful.

```r
wm_df_prepped %>%
     paran::paran()
```
<details>
  <summary>(<i>click to show/hide console output</i>)</summary>
  <!-- have to be followed by an empty line! -->

```
Results of Horn's Parallel Analysis for component retention
930 iterations, using the mean estimate

-------------------------------------------------- 
Component   Adjusted    Unadjusted    Estimated 
            Eigenvalue  Eigenvalue    Bias 
-------------------------------------------------- 
1           6.447652    6.605657      0.158005
2           5.431207    5.569971      0.138764
3           2.415137    2.538891      0.123754
4           1.715986    1.826722      0.110735
5           1.485571    1.584866      0.099294
6           1.247027    1.335573      0.088545
-------------------------------------------------- 

Adjusted eigenvalues > 1 indicate dimensions to retain.
(6 components retained)
```
</details>

*Horn's Method* suggests a number of 6 PCs to keep.
I chose to keep 8 with approximately 70 % cumulative variance.
Next, we take a look at the contributions of the original variables to each new PC.

```r
n_PCs <- 8
for (i in 1:n_PCs) {
  factoextra::fviz_contrib(wm_df_pca, "var", axes = i) %>% print
}
```

<p align = "center">
  <picture>
    <img src="img/pca_contrib_1.svg">
  </picture>
    <picture>
    <img src="img/pca_contrib_2.svg">
  </picture>
    <picture>
    <img src="img/pca_contrib_3.svg">
  </picture>
    <picture>
    <img src="img/pca_contrib_4.svg">
  </picture>
    <picture>
    <img src="img/pca_contrib_5.svg">
  </picture>
    <picture>
    <img src="img/pca_contrib_6.svg">
  </picture>
    <picture>
    <img src="img/pca_contrib_7.svg">
  </picture>
</p>


The *psych* package comes with a function that can illustrate the contribution of each original variable to the PCs in one plot.

```r
wm_df_prepped %>%
  psych::principal(nfactors = n_PCs) %>%
  psych::fa.diagram()
```
<details>
  <summary>(<i>click to show/hide</i>)</summary>
  <!-- have to be followed by an empty line! -->

<p align = "center">
  <picture>
    <img src="img/fa_diagram.png">
  </picture>
</p>
</details>

A new data set is created based on the new dimensions.

```r
wm_df_transformed_pca <- as.data.frame(-wm_df_pca$x[,1:n_PCs])
```

### Factor Analysis (FA)
Like the PCA a factor analysis can be used to reduce the dimensions of a data  set.
However, while the PCA creates uncorrelated variables the FA identifies underlying latent factors that explain the relationships among the original variables in the data set.
The factors the FA puts out might be correlated, so a rotation can be used in make these factors as uncorrelated as possible.

First, a vector containing all rotation methods is created. Then we iterate over each of them using a for-loop.

```r
rot_meth <- c("varimax", "quartimax", "equamax", "oblimin", "oblimax", "promax")

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
```
<details>
  <summary>(<i>click to show/hide console output</i>)</summary>
  <!-- have to be followed by an empty line! -->

```
Factor Analysis results. Rotation method:  varimax
Loadings:
                           Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
Flaeche                                                     0.723                         
Bevoelkerung                0.964                                                         
Bevoelkerungsdichte         0.651                          -0.670                         
Inselgemeinde                                                                             
Kuestengemeinde                                     0.322                                 
Urbanisierungsgrad         -0.725                           0.384                         
Geologischer_Indikator              0.892                                                 
Abfaelle_gesamt             0.959                                                         
Abfaelle_sortiert           0.943                                                         
Abfaelle_unsortiert         0.880                                                         
Sortierungsgrad            -0.314   0.319   0.630                           0.526         
Sort_Bio                   -0.402           0.350                           0.768         
Sort_Papier                                 0.448                                         
Sort_Glas                  -0.316           0.411                                         
Sort_Holz                           0.651                                                 
Sort_Metall                         0.438   0.371                                         
Sort_Plastik                                0.547                                         
Sort_Elektrik                               0.372                                         
Sort_Textil                                                                               
Sort_Rest                           0.494                                                 
Verwendung_Energie                  0.412                                          -0.800 
Verwendung_Deponie                 -0.508                           0.623           0.449 
Verwendung_Recycling                0.419   0.595                           0.351         
Verwendung_Unbekannt                                               -0.867                 
Steuern_gewerblich         -0.314  -0.331           0.341                                 
Steuern_privat                      0.805                                                 
Kosten_Basis                                        0.897                                 
Kosten_Sortierung                                   0.460                                 
Kosten_sonstiges                           -0.423   0.509                                 
Gebuehrenregelung_STANDARD         -0.325                                                 
Region_PAYT_Nein                   -0.807                                                 

               Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
SS loadings      5.262   4.226   2.422   1.731   1.474   1.381   1.179   1.173
Proportion Var   0.170   0.136   0.078   0.056   0.048   0.045   0.038   0.038
Cumulative Var   0.170   0.306   0.384   0.440   0.488   0.532   0.570   0.608
[enter] to show next rotation result
Factor Analysis results. Rotation method:  quartimax
Loadings:
                           Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
Flaeche                                                     0.681                         
Bevoelkerung                0.967                                                         
Bevoelkerungsdichte         0.600                          -0.701                         
Inselgemeinde                                                                             
Kuestengemeinde                    -0.311                                                 
Urbanisierungsgrad         -0.695                           0.428                         
Geologischer_Indikator              0.908                                                 
Abfaelle_gesamt             0.969                                                         
Abfaelle_sortiert           0.957                                                         
Abfaelle_unsortiert         0.883                                                         
Sortierungsgrad            -0.301           0.865                                         
Sort_Bio                   -0.405           0.806                                  -0.300 
Sort_Papier                                 0.343                                         
Sort_Glas                  -0.303                                                   0.328 
Sort_Holz                           0.633                                                 
Sort_Metall                         0.406                                           0.305 
Sort_Plastik                                0.440                                   0.315 
Sort_Elektrik                                                                             
Sort_Textil                                                                               
Sort_Rest                           0.488                                                 
Verwendung_Energie                  0.479                                  -0.791         
Verwendung_Deponie                 -0.543                          -0.645   0.390         
Verwendung_Recycling                0.343   0.723                                         
Verwendung_Unbekannt                       -0.352                   0.838                 
Steuern_gewerblich                 -0.352           0.327                                 
Steuern_privat                      0.801                                                 
Kosten_Basis                                        0.897                                 
Kosten_Sortierung                                   0.422                                 
Kosten_sonstiges                           -0.438   0.539                                 
Gebuehrenregelung_STANDARD         -0.305                                                 
Region_PAYT_Nein                   -0.833                                                 

               Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
SS loadings      5.235   4.254   3.229   1.642   1.335   1.321   1.091   0.741
Proportion Var   0.169   0.137   0.104   0.053   0.043   0.043   0.035   0.024
Cumulative Var   0.169   0.306   0.410   0.463   0.506   0.549   0.584   0.608
[enter] to show next rotation result
Factor Analysis results. Rotation method:  equamax
Loadings:
                           Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
Flaeche                     0.445                                  -0.585                 
Bevoelkerung                0.914                                                         
Bevoelkerungsdichte         0.394                                   0.845                 
Inselgemeinde                                                                             
Kuestengemeinde                                             0.321                         
Urbanisierungsgrad         -0.549                                  -0.602                 
Geologischer_Indikator              0.822          -0.326                                 
Abfaelle_gesamt             0.920                                                         
Abfaelle_sortiert           0.914                                                         
Abfaelle_unsortiert         0.820          -0.324                                         
Sortierungsgrad                             0.785                           0.403         
Sort_Bio                                    0.888                                         
Sort_Papier                                                                 0.415         
Sort_Glas                                                                   0.382         
Sort_Holz                           0.558                                                 
Sort_Metall                         0.309                                   0.439         
Sort_Plastik                                                                0.425         
Sort_Elektrik                                                               0.399         
Sort_Textil                                                                               
Sort_Rest                           0.342          -0.341                   0.340         
Verwendung_Energie                                 -0.894                                 
Verwendung_Deponie                 -0.322           0.584                           0.613 
Verwendung_Recycling                        0.614                           0.478         
Verwendung_Unbekannt                                                               -0.880 
Steuern_gewerblich                 -0.311                   0.343                         
Steuern_privat                      0.769                                                 
Kosten_Basis                                                0.918                         
Kosten_Sortierung                                           0.421                         
Kosten_sonstiges                           -0.318           0.569                         
Gebuehrenregelung_STANDARD                                                                
Region_PAYT_Nein                   -0.725           0.439                                 

               Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
SS loadings      4.362   2.971   2.562   1.984   1.904   1.903   1.723   1.438
Proportion Var   0.141   0.096   0.083   0.064   0.061   0.061   0.056   0.046
Cumulative Var   0.141   0.237   0.319   0.383   0.445   0.506   0.562   0.608
[enter] to show next rotation result
Factor Analysis results. Rotation method:  oblimin
Loadings:
                           Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
Flaeche                     0.502                          -0.688                         
Bevoelkerung                0.944                                                         
Bevoelkerungsdichte         0.365                           0.771                         
Inselgemeinde                                                                             
Kuestengemeinde                                     0.302                                 
Urbanisierungsgrad         -0.536                          -0.491                         
Geologischer_Indikator              0.879                                                 
Abfaelle_gesamt             0.940                                                         
Abfaelle_sortiert           0.936                                                         
Abfaelle_unsortiert         0.832                                                         
Sortierungsgrad                             0.690                                         
Sort_Bio                                    0.962                                         
Sort_Papier                                                         0.399                 
Sort_Glas                                                           0.425                 
Sort_Holz                           0.587                                                 
Sort_Metall                         0.302                           0.415                 
Sort_Plastik                                                        0.466                 
Sort_Elektrik                                                       0.399                 
Sort_Textil                                                                               
Sort_Rest                           0.324                           0.309                 
Verwendung_Energie                                                         -0.902         
Verwendung_Deponie                                                          0.417   0.707 
Verwendung_Recycling                        0.486                   0.391                 
Verwendung_Unbekannt                                                        0.311  -0.820 
Steuern_gewerblich                 -0.311           0.307                                 
Steuern_privat                      0.831                                                 
Kosten_Basis                                        0.953                                 
Kosten_Sortierung                                   0.447                                 
Kosten_sonstiges                                    0.563                                 
Gebuehrenregelung_STANDARD         -0.307                                                 
Region_PAYT_Nein                   -0.749                                                 

               Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
SS loadings      4.435   3.144   1.911   1.739   1.483   1.482   1.367   1.338
Proportion Var   0.143   0.101   0.062   0.056   0.048   0.048   0.044   0.043
Cumulative Var   0.143   0.244   0.306   0.362   0.410   0.458   0.502   0.545
[enter] to show next rotation result
Factor Analysis results. Rotation method:  oblimax
Loadings:
                           Factor1       Factor2       Factor3       Factor4       Factor5       Factor6       Factor7      
Flaeche                     31004397.591  31004396.902                                                                      
Bevoelkerung                  758701.705    758701.572         0.731                       0.490                            
Bevoelkerungsdichte        -31729080.429 -31729079.858         0.644                       0.595                            
Inselgemeinde               -2187807.682  -2187807.710                                                                      
Kuestengemeinde             -7400365.810  -7400366.192                                                                      
Urbanisierungsgrad          19259164.536  19259164.220        -0.646                      -0.531                            
Geologischer_Indikator       -186963.759   -186962.688         0.484        -0.307                                          
Abfaelle_gesamt              2375950.274   2375950.207         0.778                       0.488                            
Abfaelle_sortiert            2022215.383   2022215.400         0.794                       0.486                            
Abfaelle_unsortiert          2006577.555   2006577.350         0.668                       0.437                            
Sortierungsgrad             -1034425.470  -1034424.974                       0.412                       0.300              
Sort_Bio                      713676.468    713676.725        -0.341         0.442                       0.398              
Sort_Papier                   590593.238    590593.286         0.386         0.315                                          
Sort_Glas                     426189.259    426189.296        -0.350                                                        
Sort_Holz                   -3014097.254  -3014096.538         0.547                                                        
Sort_Metall                  1305037.246   1305037.729                                                                      
Sort_Plastik                  491880.015    491879.924                                                                      
Sort_Elektrik                3989953.810   3989954.015                                                                      
Sort_Textil                 -1338761.453  -1338761.432                                                                      
Sort_Rest                   -6259919.620  -6259918.927                                                                      
Verwendung_Energie           -527496.379   -527495.513                                     0.416        -0.728              
Verwendung_Deponie           3291301.220   3291300.101                       0.808        -0.416                            
Verwendung_Recycling        -2087343.065  -2087342.488                                                                      
Verwendung_Unbekannt         -698554.187   -698554.158                      -1.040                       0.550              
Steuern_gewerblich           7026936.527   7026936.098        -0.458                                                        
Steuern_privat              -1658103.331  -1658102.411         0.658                                                        
Kosten_Basis                  686585.959    686585.662                                                                 0.855
Kosten_Sortierung            2389489.034   2389488.906                                                                 0.429
Kosten_sonstiges             -765509.933   -765510.228                                                                 0.473
Gebuehrenregelung_STANDARD  -7508841.536  -7508841.800                                                                      
Region_PAYT_Nein            -5551244.994  -5551245.932        -0.435                                                        
                           Factor8      
Flaeche                            0.331
Bevoelkerung                            
Bevoelkerungsdichte                     
Inselgemeinde                           
Kuestengemeinde                         
Urbanisierungsgrad                      
Geologischer_Indikator                  
Abfaelle_gesamt                         
Abfaelle_sortiert                  0.318
Abfaelle_unsortiert                     
Sortierungsgrad                         
Sort_Bio                          -0.433
Sort_Papier                             
Sort_Glas                               
Sort_Holz                               
Sort_Metall                             
Sort_Plastik                       0.342
Sort_Elektrik                           
Sort_Textil                             
Sort_Rest                               
Verwendung_Energie                      
Verwendung_Deponie                      
Verwendung_Recycling                    
Verwendung_Unbekannt                    
Steuern_gewerblich                      
Steuern_privat                          
Kosten_Basis                            
Kosten_Sortierung                       
Kosten_sonstiges                        
Gebuehrenregelung_STANDARD              
Region_PAYT_Nein                        

                    Factor1      Factor2      Factor3      Factor4      Factor5      Factor6      Factor7      Factor8
SS loadings    2.644933e+15 2.644933e+15 5.016000e+00 2.671000e+00 2.109000e+00 1.740000e+00 1.424000e+00 1.216000e+00
Proportion Var 8.532043e+13 8.532043e+13 1.620000e-01 8.600000e-02 6.800000e-02 5.600000e-02 4.600000e-02 3.900000e-02
Cumulative Var 8.532043e+13 1.706409e+14 1.706409e+14 1.706409e+14 1.706409e+14 1.706409e+14 1.706409e+14 1.706409e+14
[enter] to show next rotation result
Factor Analysis results. Rotation method:  promax
Loadings:
                           Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
Flaeche                     0.436                                           0.749         
Bevoelkerung                1.004                                                         
Bevoelkerungsdichte         0.474                                          -0.720         
Inselgemeinde                                                                             
Kuestengemeinde                                                                           
Urbanisierungsgrad         -0.626                                           0.421         
Geologischer_Indikator                      0.965                                         
Abfaelle_gesamt             0.993                                                         
Abfaelle_sortiert           0.995                                                         
Abfaelle_unsortiert         0.870                                                         
Sortierungsgrad                     0.866                                           0.414 
Sort_Bio                            0.677                                           0.735 
Sort_Papier                         0.467                           0.326                 
Sort_Glas                           0.405                                                 
Sort_Holz                                   0.585                                         
Sort_Metall                         0.370                                                 
Sort_Plastik                        0.632  -0.370                                         
Sort_Elektrik                       0.392                                                 
Sort_Textil                                                                               
Sort_Rest                                   0.305                                         
Verwendung_Energie                                                 -0.945                 
Verwendung_Deponie                         -0.324           0.639   0.404                 
Verwendung_Recycling                0.785                                                 
Verwendung_Unbekannt                                       -0.926   0.339                 
Steuern_gewerblich                                                                        
Steuern_privat                              0.903                                         
Kosten_Basis                                        0.971                                 
Kosten_Sortierung                   0.379           0.472                                 
Kosten_sonstiges                   -0.443           0.540                                 
Gebuehrenregelung_STANDARD                 -0.323                                         
Region_PAYT_Nein                           -0.818                                         

               Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8
SS loadings      5.007   3.625   3.624   1.723   1.497   1.463   1.448   0.913
Proportion Var   0.162   0.117   0.117   0.056   0.048   0.047   0.047   0.029
Cumulative Var   0.162   0.278   0.395   0.451   0.499   0.546   0.593   0.623
```
</details>

62.3 % (promax rotation) is the maximum amount of cumulative variance with 8 factors. Approximately 10 % less than what the PCA yielded.
Additionally, the loading are ambiguous. PCA will be used.

## Cluster Analysis

To assess the clustering tendency of a data set the *Hopkins Statistic* can be used. It measures the probability that a given data set was generated by a uniform data distribution. The higher the resulting value the better the clustering tendency. Values range from 0 to 1[^4].
[^4]: Reference: https://www.datanovia.com/en/lessons/assessing-clustering-tendency/
```r
wm_df_transformed_pca %>%
  get_clust_tendency(n = nrow(wm_df_transformed_pca) - 1, graph = F)
```
<details>
  <summary>(<i>click to show/hide console output</i>)</summary>
  <!-- have to be followed by an empty line! -->

```
$hopkins_stat
[1] 0.8309369

$plot
NULL
```
</details>

~ 0.779 is quite good.

### Hierarchical Clustering: Agglomerative Methods

Clustering can be done with different approaches.
Agglomerative methods start with a cluster containing a single observation, adding more and more observations successively.
First, a distance matrix and then clusters are created. For both steps there are multiple methods of creation.

```r
dist_meth <- c("euclidean", "maximum", "manhattan", "canberra", "minkowski")
clust_meth <- c("single", "complete", "average", "mcquitty", "median", "centroid", "ward.D2")
#' *...*
```

The combination of *canberra* and *ward.D2* looks most promising.
     
```r
hclust_a <- 
  dist(scale(wm_df_transformed_pca), 
       method = "canberra") %>% 
  hclust(method = "ward.D2")
ggdendrogram(hclust_a, leaf_labels = F, labels = F) +
  labs(title = paste0("Distance: Canberra", "\nCluster: ward.D2"))
```

<p align = "center">
  <picture>
    <img src="img/dendro_man_ward.svg">
  </picture>
</p>
     
A number of 2 to 6 clusters seem to be most viable.
Microsoft Excel can be used to comfortably compare clusters for profiling and help determining the number of clusters to choose.
Using a .vba script, the differences of the means of the different clusters can be emphasised easily. I use this macro for highlighting.

<details>
  <summary>(<i>click to show/hide .vba code</i>)</summary>
  <!-- have to be followed by an empty line! -->

```vba
Sub Highlighting()
    
    Dim data_end_col As Integer
    Dim cluster_group_col As Long
    Dim cluster_count As Integer
    Dim i As Integer
    Dim j As Integer
    Dim group_end_row As Integer
    
    ' Dim chr As String
    ' get col of cluster groups
    ' chr = InputBox("ColName of cluster groupings", "Text Input", "n_Cluster")
    ' cluster_group_col = Application.WorksheetFunction.Match(chr, Range(Cells(1, 1), Cells(1, data_end_col)), 0)
    
    i = 2
    j = 2
    data_end_col = Cells(1, Columns.Count).End(xlToLeft).Column
    cluster_group_col = Application.WorksheetFunction.Match("n_Cluster", Range(Cells(1, 1), Cells(1, data_end_col)), 0)
    
    ' loop through the number of clusters
    Do While i <= ActiveSheet.UsedRange.Rows.Count
        cluster_count = Cells(i, cluster_group_col)
        group_end_row = i + cluster_count - 1
        
        ' loop through dimensions
        For j = 2 To data_end_col
            Range(Cells(i, j), Cells(group_end_row, j)).Select
            
            ' add highlighting
            Selection.FormatConditions.AddColorScale ColorScaleType:=3
            Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
            Selection.FormatConditions(1).ColorScaleCriteria(1).Type = _
                xlConditionValueLowestValue
            With Selection.FormatConditions(1).ColorScaleCriteria(1).FormatColor
                .Color = 13011546
                .TintAndShade = 0
            End With
            Selection.FormatConditions(1).ColorScaleCriteria(2).Type = _
                xlConditionValuePercentile
            Selection.FormatConditions(1).ColorScaleCriteria(2).Value = 50
            With Selection.FormatConditions(1).ColorScaleCriteria(2).FormatColor
                .Color = 16776444
                .TintAndShade = 0
            End With
            Selection.FormatConditions(1).ColorScaleCriteria(3).Type = _
                xlConditionValueHighestValue
            With Selection.FormatConditions(1).ColorScaleCriteria(3).FormatColor
                .Color = 7039480
                .TintAndShade = 0
            End With
            
        Next j
        i = group_end_row + 2
        
    Loop
End Sub
```
</details>

<p align = "center">
  <picture>
    <img src="img/profiling_hclust_a.png">
  </picture>
</p>

**...**
