Introduction to dplyr
========================================================
author: 
date: 
autosize: true

Review - Reading files
========================================================

Picking the file manually with `file.choose`


```r
surveys <- read.csv( file.choose() )
```

Review - Reading files
========================================================

Using a path (in a string).


```r
surveys <- 
  read.csv('portal_data_joined.csv')
```

Review - piping
========================================================

* Push output to next function
* First position

***


```r
library(dplyr)
pi %>%
  round(2) %>%
  as.character
```

```
[1] "3.14"
```

The advantages of piping
========================================================

* reads left-to-right
* reads top-to-bottom
* Focus on verbs
* Removes pointless nouns

***


```r
pi %>%
  round(2) %>%
  as.character
```

```
[1] "3.14"
```

Convert - Imperative
========================================================


```r
x <- pi
r_x <- 
  round(x, 2)
c_x <- 
  as.character(r_x)
```

***


```r
pi %>%
  round(2) %>%
  as.character
```

```
[1] "3.14"
```


Convert - Functions
========================================================


```r
as.character(
  round(
    pi, 2))
```

```
[1] "3.14"
```

***


```r
pi %>%
  round(2) %>%
  as.character
```

```
[1] "3.14"
```

Challenge - Convert to imperative
========================================================


```r
surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)
```

```
   species_id sex weight
1          PF   F      4
2          PF   F      4
3          PF   M      4
4          RM   F      4
5          RM   M      4
6          PF          4
7          PP   M      4
8          RM   M      4
9          RM   M      4
10         RM   M      4
11         PF   M      4
12         PF   F      4
13         RM   M      4
14         RM   M      4
15         RM   F      4
16         RM   M      4
17         RM   M      4
```

Challenge - Convert to functional
========================================================


```r
surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)
```

```
   species_id sex weight
1          PF   F      4
2          PF   F      4
3          PF   M      4
4          RM   F      4
5          RM   M      4
6          PF          4
7          PP   M      4
8          RM   M      4
9          RM   M      4
10         RM   M      4
11         PF   M      4
12         PF   F      4
13         RM   M      4
14         RM   M      4
15         RM   F      4
16         RM   M      4
17         RM   M      4
```

Simple Aggregations
========================================================


```r
surveys %>%
  summarise(
    avg_wgt = mean(weight, 
                   na.rm = TRUE))
```

```
   avg_wgt
1 42.67243
```

Group and Aggregate
========================================================


```r
grp_agg <- 
  surveys %>%
  group_by(taxa) %>%
  summarise(
    avg = mean(weight, 
               na.rm = TRUE))
```

Group and Aggregate
========================================================


```r
grp_agg 
```

```
# A tibble: 4 x 2
     taxa      avg
   <fctr>    <dbl>
1    Bird      NaN
2  Rabbit      NaN
3 Reptile      NaN
4  Rodent 42.67243
```

Filter out NAs
========================================================


```r
grp_agg <- 
  surveys %>%
  filter(!is.na(weight)) %>%
  group_by(taxa) %>%
  summarise(
    avg = mean(weight))
```

Filter out NAs
========================================================


```r
grp_agg 
```

```
# A tibble: 1 x 2
    taxa      avg
  <fctr>    <dbl>
1 Rodent 42.67243
```


Multiple Group Variables
========================================================


```r
grp_agg_2 <- 
  surveys %>%
  group_by(taxa, sex) %>%
  summarise(
    cnt = n())
```

Group and Aggregate
========================================================


```r
grp_agg_2 
```

```
# A tibble: 6 x 3
# Groups:   taxa [?]
     taxa    sex   cnt
   <fctr> <fctr> <int>
1    Bird          450
2  Rabbit           75
3 Reptile           14
4  Rodent         1209
5  Rodent      F 15690
6  Rodent      M 17348
```

Multiple Group Variables
========================================================


```r
grp_agg_3 <- 
  surveys %>%
  group_by(taxa, sex) %>%
  tally
```

Group and Aggregate
========================================================


```r
grp_agg_3 
```

```
# A tibble: 6 x 3
# Groups:   taxa [?]
     taxa    sex     n
   <fctr> <fctr> <int>
1    Bird          450
2  Rabbit           75
3 Reptile           14
4  Rodent         1209
5  Rodent      F 15690
6  Rodent      M 17348
```

Challenge - What is a tibble?
========================================================


```r
# Explore the output
surveys %>%
  group_by(taxa)
```


