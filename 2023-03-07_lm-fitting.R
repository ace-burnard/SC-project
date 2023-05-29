pacman::p_load(tidyverse, readr)
data <- read_csv(here::here("data/2023-03-01_gene-data.csv"))

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

lm1 <- lm(GE ~ treatment*concentration*CL, data = data_plotting)
summary(lm1)

lm2 <- step(lm(GE ~ 1, data = data_plotting), scope = GE ~ treatment*concentration*CL)
summary(lm2)

lm3 <- lm(GE ~ treatment*concentration, data = data_plotting)
summary(lm3)

anova(lm1, lm3) #lm1 better than lm3
anova(lm3)
summary(lm1)
anova(lm1)

library(nlme)
lme1 <- lme(GE ~ treatment*concentration, random = ~1 | sheet_names, data = data_plotting)
summary(lme1)

lme2 <- lme(GE ~ treatment*concentration*CL, random = ~1 | sheet_names, data = data_plotting)
lme2_predicted <- predict(lme2)
summary(lme2)

data_plotting %>%
  ggplot(aes(x = concentration, y = GE, color = grouping)) +
  geom_point() +
  ylim(0, NA) +
  theme_light() +
  scale_colour_brewer(palette = "Set2") +#, name = "") +
  labs(x = "Concentration (mg/ml)",
       y = "Gene expression",
       color = "Cell Line; Treatment") +
  geom_line(aes(y=lme2_predicted))
ggsave("figures/conc-ge_all-grouping_lme.svg", width = 2*plot_height, height = plot_height)

