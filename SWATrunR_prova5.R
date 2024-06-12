# Amanda Batlle Morera (a.batlle@creaf.uab.cat)
# SWATrunR test using Tordera data in SWAT2012 format.
# as per: https://chrisschuerz.github.io/SWATrunR/articles/SWATrunR.html#loading-swatrunr

library(usethis)
use_github()


# If the package remotes is not installed run first:
install.packages('remotes')

remotes::install_github('chrisschuerz/SWATrunR')

library(SWATrunR)


#### LOADING SWAT PROJECT ####
# The path where the SWAT demo project will be written
Data_path <- "C:/Users/a.batlle/OneDrive - CREAF/Documentos/local_AquaINFRA/SWAT_output/resultatsswat_2024-03-22_1305/SWATrunR/SWAT2012_rev622_TorderaProva5_data"



#### SWAT MODEL RUN ###

q_sim_2012 <- run_swat2012(project_path = Data_path,
                           output = define_output(file = 'rch',
                                                  variable = 'FLOW_OUT',
                                                  unit = 1:3))

#### EXPLORING SIMULATION OUTPUTS ####

q_sim_2012

#### PLOTTING SIMULATION OUTPUTS ####
# Loading R package for data analysis (dplyr and tidyr) and plotting (ggplot2)
library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyr)


# Prepare the SWAT2012 simulation output
q_2012 <- q_sim_2012$simulation$FLOW_OUT_3 %>%
  rename(q_2012 = run_1)  # Rename the output to q_plus

# Prepare the table for plotting
q_plot <- q_obs %>% 
  rename(q_obs = discharge) %>% # Rename the discharge column to q_obs
  filter(year(date) %in% 2003:2012) %>% # Filter for years between 2003 and 2012
  left_join(., q_2012, by = 'date') %>% # Join with the q_plus table by date
  pivot_longer(., cols = -date, names_to = 'variable', values_to = 'discharge') # Make a long table for plotting

ggplot(data = q_plot) +
  geom_line(aes(x = date, y = discharge, col = variable, lty = variable)) +
  scale_color_manual(values = c('tomato3', 'black', 'steelblue3')) +
  scale_linetype_manual(values = c('dotted', 'solid', 'dashed')) + 
  theme_bw()

ggsave("C:/Users/a.batlle/OneDrive - CREAF/Documentos/local_AquaINFRA/SWAT_output/resultatsswat_2024-03-22_1305/SWATrunR/SWAT2012_rev622_TorderaProva5_Results/FLOW_OUT_FirstRun.png")

