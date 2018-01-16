
library(dplyr)
df <- data.frame(y = mtcars$mpg, 
                 x = mtcars$disp)

model <- lm(y ~ x, df)
slope <- model$coefficients[[2]]
y_int <- model$coefficients[[1]]

df <-
  df %>%
  mutate(y_hat = y_int + slope*x) %>%
  mutate(resid_error = y - y_hat) 

df <- df %>%
  mutate(y_bar = ave(y)) 

df <-
  df %>%
  mutate(resid_total = y - y_bar) 

df <-
  df %>%
  mutate(resid_model = y_hat - y_bar)

df %>%
  summarize(SS_total = sum(resid_total**2),
            SS_error = sum(resid_error**2),
            SS_model = sum(resid_model**2))


plot(df$x, df$y)
abline(y_int, slope)
points(df$x, df$y_hat, pch = 16, cex = 1.3, col = "blue")
segments(df$x, df$y_hat, df$x, df$y, col = "blue")

plot(df$x, df$y)
abline(y_int, slope)
abline(mean(df$y), 0)
points(df$x, df$y_hat, pch = 16, cex = 1.3, col = "dark green")
points(df$x, df$y_bar, pch = 16, cex = 1.3, col = "dark green")
segments(df$x, df$y_hat, df$x, df$y_bar, col = "dark green")

y_bar = mean(df$y)
x_bar <- mean(df$x)
s_y <- sd(df$y)
s_x <- sd(df$x)
n <- length(df$x)

df %>%
  mutate(y_thing = (y - mean(y))/sd(y),
         x_thing = (x - mean(x))/sd(x)) %>%
  summarize(r = sum(x_thing*y_thing)/(n-1))


plot(df$x, df$y)
abline(mean(df$y), 0)
points(df$x, df$y_bar, pch = 16, cex = 1.3, col = "purple")
segments(df$x, df$y, df$x, df$y_bar, col = "purple")

model <- lm(y ~ x, df)
model_summary <- summary(model)
model_summary$r.squared

quad_model <- lm(y ~ poly(x, 2), df)

  