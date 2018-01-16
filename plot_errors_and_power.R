require(cowplot)

n <- 20
x <- 0:n
crit_val <- qbinom(0.1, 20, 0.6) - 1


# function for plotting a binomial less than test
plot_less_than_HT_binomial <- function(n, p, crit_val, my_title) {
probs <- dbinom(0:n, n, p)
max_prob <- max(probs)
dat <- data.frame(k = 0:n, prob = dbinom(0:n, n, p))
plot <- ggplot(dat, aes(x = k, y = prob))
plot <- plot + geom_segment(aes(xend = k, yend = 0), size = 1) + ylab('p(k)') + ggtitle(my_title)
plot <- plot + annotate("rect", xmin = crit_val, xmax = n, ymin = 0, ymax = 1.1*max_prob, alpha = 0.2, fill = "red", colour = "red")
plot <- plot + annotate("rect", xmin = 0, xmax = crit_val, ymin = 0, ymax = 1.1*max_prob, alpha = 0.2, fill = "blue", colour = "blue")
plot <- plot + annotate("text", label = "Reject H0", x = 2, y = max_prob, colour = "blue")
plot <- plot + annotate("text", label = "Fail to Reject H0", x = n - 2, y = max_prob, colour = "red")
return(plot)}

create_title <- function(prefix, p_val) {
return(substitute(paste(prefix, " (", p == p_val, ")"), list(prefix = prefix, p_val = p_val)))
}

plot_null_real_less_than_HT_binomial <- function(n, p_null, p_alt, alpha) {
crit_val <- qbinom(alpha, n, p_null) - 1
plot_null <- plot_less_than_HT_binomial(n, p_null, crit_val,  create_title("Null", p_null))
plot_alt <- plot_less_than_HT_binomial(n, p_alt, crit_val, create_title("Real", p_alt))
plot_grid(plot_null, plot_alt, ncol = 1, align = "v")
}
# a Plot of the Null distribution (type = 'h' give lines in place of bars)
p_null <- 0.6
p_real <- 0.5

plot_null_real_less_than_HT_binomial(20, 0.6, 0.35, 0.1)

