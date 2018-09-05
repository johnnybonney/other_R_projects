#' Author: John Bonney (adapting code from Clause Wilke)
#' Date: 9/3/2018
#' 
#' Purpose: Visualize bootstrap estimation.
#' See https://github.com/clauswilke/ungeviz/blob/master/README.md#bootstrapping for source of code

setwd("C:/Users/John Bonney/Desktop/other_R_projects")

#to install the ungeviz package, author Claus Wilke
#devtools::install_github("clauswilke/ungeviz")

# to install gganimate (workaround since computer is being buggy about Rtools)
# library(devtools)
# assignInNamespace("version_info", c(devtools:::version_info, list("3.5" = list(version_min = "3.3.0", version_max = "99.99.99", path = "bin"))), "devtools")
# find_rtools()
# devtools::install_github('thomasp85/gganimate')

library(magrittr)
library(tidyverse)
library(ungeviz)
library(dplyr)
library(gganimate)
library(broom)
library(tidyr)
library(magick)

# data obtained from https://ww2.amstat.org/publications/jse/v4n1/datasets.johnson.html
bmi_data <- read.csv("bmi_data.csv")

bs <- ungeviz::bootstrapper(20)
animated_bootstrap <- ggplot(bmi_data, aes(height, weight, color = sex)) +
                      geom_smooth(method = "lm", color = NA) +
                      geom_point(alpha = 0.3) +
                      # `.row` is a generated column providing a unique row number
                      # to all rows in the bootstrapped data frame 
                      geom_point(data = bs, aes(group = .row)) +
                      geom_smooth(data = bs, method = "lm", fullrange = TRUE, se = FALSE) +
                      facet_wrap(~sex, scales = "free_x") +
                      scale_color_manual(values = c(M = "#D55E00"), guide = "none") +
                      theme_bw() +
                      transition_states(.draw, 1, 1) + 
                      enter_fade() + 
                      exit_fade()

bootstrap_gif <- animate(animated_bootstrap)
save.gif <- image_read(bootstrap_gif)
image_write(save.gif, "bootstrap.gif")
