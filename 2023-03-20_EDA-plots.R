pacman::p_load(tidyverse, readr)
data <- read_csv(here::here("data/2023-03-01_gene-data.csv"))

theme_set(theme_bw())

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

plot_height <- 5

data_plotting %>%
  ggplot(aes(x = concentration, y = `gene expression`)) +
  geom_point() +
  labs(x = "Concentration (mg/ml)",
       y = "Gene expression")
ggsave("figures/conc-ge_scatterplot.svg", width = 2*plot_height, height = plot_height)

data_plotting %>%
  ggplot(aes(x = `cell line`, y = `gene expression`, col = `cell line`)) +
  geom_boxplot() +
  theme(legend.position = 'none') +
  harrypotter::scale_color_hp_d("Ravenclaw") +
  labs(x = "Cell line",
       y = "Gene expression")
ggsave("figures/cellline-ge_boxplot.svg", width = 1.2*plot_height, height = plot_height)

data_plotting %>%
  ggplot(aes(x = treatment, y = `gene expression`, col = treatment)) +
  geom_boxplot() +
  theme(legend.position = 'none') +
  harrypotter::scale_color_hp_d("Ravenclaw") +
  labs(x = "Treatment",
       y = "Gene expression")
ggsave("figures/treatment-ge_boxplot.svg", width = 1.22*plot_height, height = plot_height)

data_plotting %>%
  ggplot(aes(x = concentration, y = `gene expression`, col = grouping)) +
  geom_point() +
  facet_grid(treatment ~ `cell line`) +
  theme(legend.position = 'none') +
  harrypotter::scale_color_hp_d("Ravenclaw") +
  labs(x = "Concentration (mg/ml)",
       y = "Gene expression")
ggsave("figures/conc-ge_scatterplot_facet-treatment-cellline.svg", width = 1.2*plot_height, height = plot_height)

