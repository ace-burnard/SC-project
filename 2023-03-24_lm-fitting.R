pacman::p_load(tidyverse, readr)
data <- read_csv("data/2023-03-01_gene-data.csv")

data_plotting <- data %>%
  mutate(CL = `cell line`,
         treat = treatment) %>%
  unite(`cell line`, `treat`, sep = "; ", col = "grouping") %>%
  pivot_longer(cols = 4:14, names_to = "concentration", values_to = "GE") %>%
  filter(GE >= 0) %>%
  mutate(concentration = as.integer(concentration),
         sheet_names = as.factor(sheet_names),
         CL = as.factor(CL),
         treatment = as.factor(treatment),
         grouping = as.factor(grouping))

lm1_data <- data_plotting %>%
  filter(CL == "wild-type")
lm1 <- lm(GE ~ treatment*concentration, data = lm1_data)
summary(lm1)

lm2_data <- data_plotting %>%
  filter(CL != "wild-type")
lm2 <- lm(GE ~ treatment+concentration, data = lm2_data)
summary(lm2)
lm3 <- lm(GE ~ treatment*concentration, data = lm2_data)
summary(lm3)
anova(lm2, lm3)

plot_height <- 5

data_plotting %>%
  ggplot(aes(x = concentration, y = GE, color = treatment)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  facet_wrap(~CL) +
  harrypotter::scale_color_hp_d("Ravenclaw") +
  labs(x = "Concentration (mg/ml)",
       y = "Gene expression",
       color = 'Treatment') +
  theme_bw()
ggsave("figures/conc-ge_scatterplot_facet-cellline_lm.svg", width = 2*plot_height, height = plot_height)
