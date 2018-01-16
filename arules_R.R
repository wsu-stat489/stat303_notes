groceries <- read.csv("Groceries.csv",
                      header = TRUE,
                      sep=",")
head(groceries)

#### Butter -> Milk
#
# Steps
# Step 0. Get the total number of rows (needed in the demonimator)


# 1. Select the butter and milk columns
#   a. Save in a new data frame
library(dplyr)
 N <- nrow(groceries)
butter_milk <- groceries %>%
  select("butter", "whole.milk")
head(butter_milk)


# 2. Compute the support of Butter

#
###  Method 1 - Filter and summarize
#
#   a. filter on butter == 1
#   b. summarize with total

total_butter <- 
  butter_milk %>%
  filter(butter == 1) %>%
  summarize(total_butter = sum(butter)/N)
total_butter


# We could just jump right to the support (total_butter/N)
support_butter <- butter_milk %>%
  filter(butter == 1) %>%
  summarize(total_butter = sum(butter)/N)
support_butter

#
### Method 2 - Mutate and summarize
#
# Recall: TRUE + TRUE + FALSE = 2 (TRUE -> 1 and FALSE -> 0 )


support_butter <- butter_milk %>%
  mutate(bought_butter = butter == 1) %>%
  summarize(total_butter = sum(butter)/N)
support_butter

### Exercise - Compute the support of whole.milk

support_milk <- 
  butter_milk %>%
  mutate(bought_milk = whole.milk == 1) %>%
  summarize(total_milk = sum(bought_milk)/N)
support_milk

# 3. Do the same with whole.milk == 1 AND butter == 1
support_butter_milk <- 
  butter_milk %>%
  mutate(bought_butter_and_milk = (butter == 1 & whole.milk == 1)) %>%
  summarize(total_butter = sum(bought_butter_and_milk)/N)
support_butter_milk

# 4. Compute the confidence (support butter & milk/ support butter)

conf_butter_milk <- support_butter_milk/support_butter
conf_butter_milk

# 5. Compute lift (confidence/support whole milk)

lift_butter_milk <- conf_butter_milk/support_milk
lift_butter_milk

#
### Putting it all together
#

# The code above follows the imperative pattern

# df2 <- f(df1)
# df3 <- f(df2)
# etc.

# Let's clean this up, putting it all in one pipe.
# Note: Take them through combining the code
# Questions: Why do we need to do all the mutates before summarize?
#            Why do we need to do lift in a separate mutate?
#            Why don't we put the read.csv in this pipe/chain?

butter_milk_piped <- 
  groceries %>%
  mutate(bought_butter = butter == 1,
         bought_milk = whole.milk == 1,
         bought_butter_and_milk = (butter == 1 & whole.milk == 1)) %>%
  summarize(supp_butter = sum(bought_butter)/N,
            supp_milk = sum(bought_milk)/N,
            supp_butter_milk = sum(bought_butter_and_milk)/N) %>%
  mutate(conf = supp_butter_milk/supp_butter) %>%
  mutate(lift = conf/supp_milk)
butter_milk_piped

# Refactoring - Round 2
# Now we simplify the code
# Note that we don't need to switch the butter and milk columns to logical
# BUT, we need to know that butter == 1 & whole.milk == 1 is equivalent to 
# butter * whole.milk


butter_milk_piped <- 
  groceries %>%
  summarize(supp_butter = sum(butter)/N,
            supp_milk = sum(whole.milk)/N,
            supp_butter_milk = sum(butter*whole.milk)/N) %>%
  mutate(conf = supp_butter_milk/supp_butter) %>%
  mutate(lift = conf/supp_milk)
butter_milk_piped

#
### All rules of the form {X} -> {whole.milk}
#

# THE TRICK!  Stack all the columns except whole milk

# Let's try
groceries %>%
  gather(-whole.milk) %>%
  head() # Note the bad column names

groc_stacked <-
  groceries %>%
  gather(-whole.milk) %>%
  setNames(c("LHS", "whole.milk"))

head(groc_stacked) # Better

# Try to see the levels of LHS

summary(groc_stacked)

# Need to switch LHS to a factor

groc_stacked_factor <-
  groc_stacked %>%
  mutate(LHS_factor = as.factor(LHS)) %>%
  select(LHS = LHS_factor, whole.milk)

head(groc_stacked_factor)
str(groc_stacked_factor$LHS)  # 169 levels == 169 products


#
###  Use groupby to group and aggregate
#

# Example data frame
df <- data.frame("a" = c(1,2),
                 "b" = c(3,4),
                 "c" = c(5,6),
                 "d" = c(7,8))
df

# Stack a, b, c
library(tidyr)
stacked <- df %>%
  gather(key = "Label",
         value = "Value",
         a, b, c)
stacked

# all but one column

stacked <- df %>%
  gather(key = "Label",
         value = "Value",
         -d)
stacked

# Group and Aggregate

stacked %>%
  group_by(Label) %>%
  summarize(mean = mean(Value))

#
#
### Many rules at once
#
#

# Step 0 - Read the data and load libraries
# Be sure to change the working directory
library(tidyr)
library(dplyr)

groceries <- read.csv("Groceries.csv",
                      header = TRUE,
                      sep=",")
head(groceries)
N <- nrow(groceries)


# If we stack all the other product, we can use the same approach for MANY rules.

# Step 1 - Stack all of the other products
groceries_stacked <-
  groceries %>%
  gather(key = "Other_Product",
         value = "Purchased",
         -whole.milk)
head(groceries_stacked)

# Step 3 - Compute the support, confidence, and lift for each
# Note that we group_by the products to keep them separate.
many_rules <-
groceries_stacked %>%
  group_by(Other_Product) %>%
  summarize(support_milk = sum(whole.milk)/N,
            support_lhs = sum(Purchased)/N,
            support_both = sum(Purchased*whole.milk)/N) %>%
  mutate(confidence = support_both/support_lhs) %>%
  mutate(lift = confidence/support_milk) %>%
  select(Other_Product, support_lhs, confidence, lift)

head(many_rules)

#
#### Putting it all together - Refactor
#


# Step 1 - Stack all of the other products
many_rules <-
  groceries %>%
  gather(key = "Other_Product",
         value = "Purchased",
         -whole.milk) %>%
  group_by(Other_Product) %>%
  summarize(support_milk = sum(whole.milk)/N,
            support_lhs = sum(Purchased)/N,
            support_both = sum(Purchased*whole.milk)/N) %>%
  mutate(confidence = support_both/support_lhs) %>%
  mutate(lift = confidence/support_milk) %>%
  select(Other_Product, support_lhs, confidence, lift)

head(many_rules)

#
#### Automate the process with the arules library
#

# Run once
# install.packages("arules")

library(arules)

# this package requires all of the zero/one columns to be factors

# Switch to factors
groc_factors <-
  groceries %>%
  mutate_if(is.integer, as.factor)

# Make a transaction object
groc_trans <-
  as(groc_factors, "transactions")

# Compute the rules
groc_rules <- apriori(groc_trans, 
                      parameter = list(supp = 0.0,
                                       conf = 0.0,
                                       maxlen = 2))

#
### Refactor to put it all together
#

# Switch to factors
groc_rules <-
  groceries %>%
  mutate_if(is.integer, as.factor) %>%
  as("transactions") %>%
  apriori(parameter = list(supp = 0.0, 
                           conf = 0.0, 
                           maxlen = 2)) 
groc_rules

# Find milk rules
rules_with_milk <- 
  subset(groc_rules, 
         subset = rhs %in% "whole.milk=1")
inspect(sort(rules_with_milk, by = "lift")[1:10])


# Point out the functional pattern
# refactor to a pipe

rules_with_milk <- 
  groc_rules %>%
  subset(subset = rhs %in% "whole.milk=1") %>%
  sort(by = "lift") %>%
  inspect() %>%
  head(10)
rules_with_milk

# Questions: Why is the pipe more appealing than the functional pattern?
#            Composition is awesome, so why might we not want to combine this with
#            the last pipe?
#

#
#### Visualizing rules
#
#

outcomes<-head(sort(groc_rules,by="lift"),20)

library(arulesViz)
plot(outcomes, method="grouped")
