xs <- c(15, 20, 11, 30, 33,
        20, 29, 35, 8, 10,
        22, 37, 15, 25)

qqnorm(xs)
qqline(xs)

one_sample_mean <- mean(rexp(20, 1/10))
ten_sample_means <- replicate(10, mean(rexp(20, 1/10)))
one_k_sample_means <- replicate(1000, mean(rexp(20, 1/10)))
one_mil_sample_means <- replicate(1000000, mean(rexp(20, 1/10)))

hist(one_mil_sample_means)
hist(one_mil_sample_means, 
     nclass = 100)
hist(one_mil_sample_means, 
     nclass = 100, 
     probability = TRUE)
