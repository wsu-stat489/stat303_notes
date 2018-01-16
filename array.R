library(dplyr)

# images: 4
# dim: 3x3
# bands: 2
x <- 1:36
y <- 37:72


out <- 
    rbind(x,y) %>% 
    c %>%
    array(dim=c(2,3,3,4)) %>% 
    aperm(c(4,3,2,1))

out[1,,,]