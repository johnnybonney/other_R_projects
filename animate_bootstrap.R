#' Author: John Bonney (adapting code from Clause Wilke)
#' Date: 9/3/2018
#' 
#' Purpose: Visualize bootstrap estimation

#to install the ungeviz package, author Claus Wilke
#devtools::install_github("clauswilke/ungeviz")

library(tidyverse)
library(ungeviz)
library(gganimate)
library(broom)

data(BlueJays, package = "Stat2Data")

BlueJays %>% group_by(KnownSex) %>%
  bootstrap_do(20,
               tidy(lm(BillWidth ~ BillDepth, data = .))
  ) %>%
  select(KnownSex, .draw, term, estimate) %>%
  spread(term, estimate) %>%
  ggplot(aes(BillDepth, BillWidth)) +
  geom_point(data = BlueJays, color = "#0072B2") +
  geom_smooth(data = BlueJays, method = "lm", color = NA) +
  geom_abline(aes(slope = BillDepth, intercept = `(Intercept)`)) +
  facet_wrap(~KnownSex, scales = "free_x") +
  transition_states(.draw, 1, 1)