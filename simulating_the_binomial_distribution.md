Simulating the Binomial Distribution
========================================================
author: 
date: 
autosize: true

Sampling from the Binomial - The Long Way
========================================================

- Suppose we want to simulate with...
  - $P(Success) = p$ and a sample size of $n$
- Use the following process
  - Make a container with $100*p$% `"S"` and $100*(1 - p)$% `"F"`
  - Sample as usual with `sample` and `replicate`
  - Use `mutate` to compute the number of successes
  
Example 1: Sampling from the Binomial - The Long Way
========================================================


```r
library(dplyr)
coin <- c("S", "S", "S", "F", "F")
replicate(100, sample(coin, 3, replace = TRUE)) %>% t() %>% 
  as.data.frame() %>%
  setNames(c("T1", "T2", "T3")) %>%
  mutate(num_success = (T1 == "S") + (T2 == "S") + (T3 == "S")) %>%
  head()
```

```
  T1 T2 T3 num_success
1  S  F  F           1
2  S  S  S           3
3  F  S  F           1
4  S  S  F           2
5  S  S  F           2
6  S  F  S           2
```

Sampling from the Binomial - The Fast Way
========================================================

- This process is built into R
- Use the function `dbinom`
- Syntax: `rbinom(N, n, p)`
-Where
  - `N` is the number of trials
  - `n` is the sample size of each trial
  - `p` is the probability of success

Example 1: Sampling from the Binomial - The Fast Way
========================================================


```r
data.frame(num_success = rbinom(100, 3, 0.6)) %>%
  head()
```

```
  num_success
1           0
2           2
3           1
4           3
5           2
6           2
```

Example 2 - Approximate with a Simulation
=======================================================

- **Story:**As a lawyer for a client accused of murder, you are looking to establish “reasonable doubt.”  An expert testified that a blood sample taken from the scene matches your client.  These tests are in error 1% of the time.
- **Note:** Here *Success* is an *error*

- **Question:** Suppose that your client is guilty.  If you test the sample at 6 other labs, what is the probability that at least one lab makes a mistake and concludes your client is innocent?

Step 1 - Create the notebook
=======================================================


```r
df <- data.frame(num_success = rbinom(10000, 6, 0.01))
head(df)
```

```
  num_success
1           0
2           0
3           0
4           0
5           0
6           0
```

Step 2 - mutate based on the question
=======================================================


```r
# Q: P(At least 1 "S") 
df <- df %>%
       mutate(at_least_1 = num_success >= 1)
head(df)
```

```
  num_success at_least_1
1           0      FALSE
2           0      FALSE
3           0      FALSE
4           0      FALSE
5           0      FALSE
6           0      FALSE
```

Step 3 - summarize to estimate the probability
=======================================================


```r
# Q: P(At least 1 "S") 
df %>%
  summarize(prob_success = mean(at_least_1))
```

```
  prob_success
1       0.0602
```

Computing the exact probabilities in R
=======================================================

- R also has the exact probability built in.
- Use the function `dbinom`
- Syntax: `dbinom(range, n, p)`
- Where
  - `range` is the range of values (like `1:6`)
  - `n` is the sample size of each trial
  - `p` is the probability of success
  
Example 2 - Computing the Exact Probability
=======================================================


```r
probs <- dbinom(1:6, 6, 0.01)
probs
```

```
[1] 5.705940e-02 1.440894e-03 1.940598e-05 1.470150e-07 5.940000e-10
[6] 1.000000e-12
```

```r
ans <- sum(probs)
ans
```

```
[1] 0.05851985
```
