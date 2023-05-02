pacman::p_load(tidyverse, readr)
data <- read_csv("data/2023-03-01_gene-data.csv")

data_plotting <- data %>%
  mutate(CL = `cell line`,
         treat = treatment) %>%
  unite(`CL`, `treat`, sep = "; ", col = "grouping") %>%
  pivot_longer(cols = 4:14, names_to = "concentration", values_to = "gene expression") %>%
  filter(`gene expression` >= 0) %>%
  mutate(concentration = as.integer(concentration),
         sheet_names = as.factor(sheet_names),
         `cell line` = as.factor(`cell line`),
         treatment = as.factor(treatment),
         grouping = as.factor(grouping))

#colour palettes
# RColorBrewer::display.brewer.all()

plot_height <- 5
#plot of concentration (x) vs gene expression (y), coloured by grouping (both cell line and treatment)
data_plotting %>%
  ggplot(aes(x = concentration, y = `gene expression`, color = grouping)) +
  geom_point() +
  ylim(0, NA) +
  theme_light() +
  harrypotter::scale_color_hp_d("Ravenclaw") +
  labs(x = "Concentration (mg/ml)",
       y = "Gene expression",
       color = "Cell Line; Treatment")
ggsave("figures/conc-ge_all-grouping_datapoints.svg", width = 2*plot_height, height = plot_height)
data_plotting %>% #with fitted curves
  ggplot(aes(x = concentration, y = `gene expression`, color = grouping)) +
  geom_point() +
  geom_smooth() +
  ylim(0, NA) +
  theme_light() +
  harrypotter::scale_color_hp_d("Ravenclaw") +
  labs(x = "Concentration (mg/ml)",
       y = "Gene expression",
       color = "Cell Line; Treatment")
ggsave("figures/conc-ge_all-grouping_lm.svg", width = 2*plot_height, height = plot_height)

#plot of concentration (x) vs gene expression (y), coloured by cell line
data_plotting %>%
  ggplot(aes(x = concentration, y = `gene expression`, color = `cell line`)) +
  geom_point() +
  ylim(0, NA) +
  theme_light() +
  harrypotter::scale_color_hp_d("Ravenclaw") + #scale_colour_brewer(palette = "Paired") +
  labs(x = "Concentration (mg/ml)",
       y = "Gene expression",
       color = "Cell Line")
ggsave("figures/conc-ge_cell-line_datapoints.svg", width = (8/5)*plot_height, height = plot_height)
data_plotting %>% #with fitted curves
  ggplot(aes(x = concentration, y = `gene expression`, color = `cell line`)) +
  geom_point() +
  geom_smooth() +
  ylim(0, NA) +
  theme_light() +
  harrypotter::scale_color_hp_d("Ravenclaw") + #scale_colour_brewer(palette = "Paired") +
  labs(x = "Concentration (mg/ml)",
       y = "Gene expression",
       color = "Cell Line")
ggsave("figures/conc-ge_cell-line_lm.svg", width = (8/5)*plot_height, height = plot_height)

#plot of concentration (x) vs gene expression (y), coloured by treatment
data_plotting %>%
  ggplot(aes(x = concentration, y = `gene expression`, color = treatment)) +
  geom_point() +
  ylim(0, NA) +
  theme_light() +
  harrypotter::scale_color_hp_d("Ravenclaw") +
  # scale_colour_manual(values = c("#B2DF8A", "#33A02C")) +
  # scale_colour_brewer(palette = "Paired") +
  labs(x = "Concentration (mg/ml)",
       y = "Gene expression",
       color = "Treatment")
ggsave("figures/conc-ge_treatment_datapoints.svg", width = (8/5)*plot_height, height = plot_height)
data_plotting %>% #with fitted curves
  ggplot(aes(x = concentration, y = `gene expression`, color = treatment)) +
  geom_point() +
  geom_smooth() +
  ylim(0, NA) +
  theme_light() +
  harrypotter::scale_color_hp_d("Ravenclaw") +
  # scale_colour_manual(values = c("#B2DF8A", "#33A02C")) +
  # scale_colour_brewer(palette = "Paired") +
  labs(x = "Concentration (mg/ml)",
       y = "Gene expression",
       color = "Treatment")
ggsave("figures/conc-ge_treatment_lm.svg", width = (8/5)*plot_height, height = plot_height)

