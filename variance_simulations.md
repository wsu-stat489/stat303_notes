Variance Simulations
========================================================
author: 
date: 
autosize: true

Three Ways to Compute Variance
========================================================

- **Brute force**
  - `var(trials)`
- **Definition:** $E\left((X-\mu)^2\right)$
  - `mean((trials - mu)^2)`
- **Short Cut formula:** $E(X^2) - \mu^2$
  - `mean(trials^2) - mean(trials)^2`

Example 1
========================================================

- Urn as pictured below
- Draw three chips
- Count number of red chips

![Urn](./urn.png)

Simulation Setup
========================================================


```r
library(dplyr)
urn <- c("R", "R", "R", "R", "B","B","B","B","B")
df <- replicate(100000, sample(urn, 3, replace = FALSE)) %>%
       t() %>%
       as.data.frame() %>%
       setNames(c("Draw_1", "Draw_2", "Draw_3"))
head(df)
```

```
  Draw_1 Draw_2 Draw_3
1      B      R      R
2      R      B      R
3      R      B      B
4      B      B      R
5      B      B      R
6      B      B      B
```

Compute the Random Variable
========================================================


```r
df <- df %>%
       mutate(num_red = (Draw_1 == "R") +
                        (Draw_2 == "R") +
                        (Draw_3 == "R"))
head(df)
```

```
  Draw_1 Draw_2 Draw_3 num_red
1      B      R      R       2
2      R      B      R       2
3      R      B      B       1
4      B      B      R       1
5      B      B      R       1
6      B      B      B       0
```

Compute the Variance - Brute Force
========================================================


```r
df %>%
  summarize(var_brute = var(num_red))
```

```
  var_brute
1   0.55668
```

Compute the Variance - Definition
========================================================


```r
df %>%
  summarize(var_def = mean((num_red - mean(num_red))^2))
```

```
    var_def
1 0.5566744
```

Compute the Variance - Short Cut
========================================================


```r
df %>%
  summarize(var_def = mean(num_red^2) - mean(num_red)^2)
```

```
    var_def
1 0.5566744
```
