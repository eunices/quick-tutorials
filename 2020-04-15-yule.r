# http://varianceexplained.org/r/spam-simulation/  # r code
# https://www.youtube.com/watch?v=QtThluGted0      # how he approached the problem

library(ggplot2)
library(data.table) # alternative code
library(tidyverse)  # original code

# p(spammer making new comment prop. to length of time interval)
# on average, column gets 1 new comment spam/ day
# each spam comment gets reply at an average of 1 per day

# e.g. after 3 days, i have 4 non-reply comments

# after three days, how many total spam posts (comments + replies)
# can i expect to have?



################################
################################
################################
################################


# Doing it in 1 line (original)

waiting_times <- rexp(20, 1:20)
cumsum(waiting_times) # cumulative time

sum(cumsum(rexp(20, 1:20)) < 3)

sim <- replicate(1e6, sum(cumsum(rexp(300, 1:300)) < 3))
mean(sim, na.rm=T)


################################
################################
################################
################################


# An exact solution (alternative)

trials = 25000
observations = 300
sim_waiting = data.table(expand.grid(trial=1:trials, observation=1:observations))

## simulate time gap between each comment
sim_waiting$waiting = rexp(nrow(sim_waiting), sim_waiting$observation) 

sim_waiting[, cumulative := cumsum(waiting), by="trial"] # sum comments at each t
sim_waiting = sim_waiting[order(trial, observation)]
sim_summary = sim_waiting[, list(num_comments=sum(cumulative <= 3)), by="trial"] # number of comments at t=3
mean(sim_summary$num_comments)


# Comments over time (alternative)

average_over_time = crossing(sim_waiting, time=seq(0,3,.25))  # duplicate these times for each row
average_over_time = data.table(average_over_time)

## count number of comments at each time point for each trial
average_over_time =
  average_over_time[, list(num_comments=sum(cumulative < time)), by=c("time", "trial")]

## tabulate mean number of comments at each time point
ggplot(average_over_time[, list(average=mean(num_comments)), by=time], aes(time, average)) +
  geom_line(aes(y=exp(time)-1), color = "red") + # fit exp curve
  geom_point() + theme_minimal() +
  labs(y = "Mean # of comments", x="Time",
       title = "How many comments over time?",
       subtitle = "Points show simulation, red line shows exp(time) - 1.")

ggplot(sim_waiting[trial <=50 & cumulative <=3], aes(cumulative, observation)) +
  geom_line(aes(group = trial), alpha = .25) +
  geom_line(aes(y = exp(cumulative) - 1), color = "red", size = 1) +
  labs(x = "Time",
        y = "# of comments",
        title = "50 possible paths of comments over time",
        subtitle = "Red line shows e^t - 1") + theme_minimal()


# Distribution of comments at time t (alternative)
num_comments <- data.table(num_comments = sim)
p <- exp(-3)

# a geometric distribution: the expected number of "tails flipped before we see the first "heads"
# pmf = (1-p)^n * p; E(X) = e^3-1
# thus rate parameter p = e^(-3)
# https://en.wikipedia.org/wiki/Geometric_distribution

ggplot(num_comments[num_comments<=150], aes(num_comments)) + 
  geom_histogram(aes(y=..density..), binwidth = 1) + 
  geom_line(aes(y = (1 - p) ^ num_comments * p), color = "red") +
  theme_minimal()


################################
################################
################################
################################


# An exact solution (original)

sim_waiting <- crossing (trial = 1:25000, observation = 1:300) %>%
  mutate(waiting = rexp(n(), observation)) %>%
  group_by(trial) %>%
  mutate(cumulative = cumsum(waiting)) %>%
  ungroup()

sim_waiting %>%
  group_by(trial) %>%
  summarize(num_comments = sum(cumulative <= 3)) %>%
  summarize(average = mean(num_comments))

average_over_time <- sim_waiting %>%
  crossing(time = seq(0, 3, .25)) %>%
  group_by(time, trial) %>%
  summarize(num_comments = sum(cumulative < time)) %>%
  summarize(average = mean(num_comments))

ggplot(average_over_time, aes(time, average)) +
  geom_line(aes(y = exp(time) - 1), color = "red") +
  geom_point() +
  labs(y = "Average # of comments",
       title = "How many comments over time?",
       subtitle = "Points show simulation, red line shows exp(time) - 1.")


# Distribution of comments at a given time (original)
sim_waiting %>%
  filter(trial <= 50, cumulative <= 3) %>%
  ggplot(aes(cumulative, observation)) +
  geom_line(aes(group=trial), alpha=.25) +
  geom_line(aes(y=exp(cumulative) - 1), color="red", size=1) +
  labs(x = "Time",
       y = "# of comments",
       title = "50 possible paths of comments over time",
       subtitle = "Red line shows e^t - 1")


# We'll use the million simulated values from earlier (original)
num_comments <- tibble(num_comments = sim)

p <- exp(-3)

num_comments %>%
  filter(num_comments <= 150) %>%
  ggplot(aes(num_comments)) +
  geom_histogram(aes(y = ..density..), binwidth = 1) +
  geom_line(aes(y = (1 - p) ^ num_comments * p), color = "red")

