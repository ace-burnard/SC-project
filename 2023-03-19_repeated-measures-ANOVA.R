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

# pacman::p_load(rstatix, reshape, tidyverse, dplyr, ggpubr, plyr, datarium)
# one.way <- data_plotting %>%
#   group_by(concentration) %>%
#   anova_test(dv = GE, wid = sheet_names, within = treatment) %>%
#   get_anova_table() %>%
#   adjust_pvalue(method = "bonferroni")
# one.way

library(reshape2)
data_long <- data %>%
  mutate(CL = `cell line`,
         treat = treatment) %>%
  unite(`cell line`, `treat`, sep = "; ", col = "grouping") %>%
  mutate(id = sheet_names) %>%
  # mutate(id = as.factor(sheet_names),
  #        CL = as.factor(CL),
  #        treatment = as.factor(treatment),
  #        grouping = as.factor(grouping)) %>%
  melt(id.vars = c('id', 'grouping'),
       measure.vars = c('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'),
       variable.name = "concentration",
       value.name = "GE")
head(data_long)

ex1 <- aov(GE ~ concentration + Error(id/concentration), data = data_long)
summary(ex1)

ex2 <- aov(GE ~ concentration*grouping + Error(id/(concentration*grouping)), data = data_long)
summary(ex2)

data("selfesteem", package = 'datarium')
head(selfesteem)
selfesteem <- selfesteem %>%
  gather(key = "time", value = "score", t1, t2, t3) %>%
  convert_as_factor(id, time)
head(selfesteem)
res.aov <- anova_test(data = selfesteem, dv = score, wid = id, within = time)
get_anova_table(res.aov)
pwc <- selfesteem %>%
  pairwise_t_test(score ~ time, paired = TRUE, p.adjust.method = "bonferroni")
pwc
pwc <- pwc %>%
  add_xy_position(x = "time")
bxp <- ggboxplot(selfesteem, x = 'time', y = 'score', add = 'point')
bxp
bxp +
  stat_pvalue_manual(pwc) +
  labs(subtitle = get_test_label(res.aov, detailed = TRUE),
       caption = get_pwc_label(pwc))

data_aov <- data %>%
  gather(key = "conc", value = "GE", '0','1','2','3','4','5','6','7','8','9','10') %>%
  convert_as_factor(sheet_names)
head(data_aov)
res.aov <- anova_test(data = data_aov, dv = GE, wid = sheet_names, within = conc)
get_anova_table(res.aov) #gene expression is stat significant at the different concentrations
pwc <- data_aov %>%
  pairwise_t_test(GE ~ conc, paired = TRUE, p.adjust.method = "bonferroni")
pwc
pwc <- pwc %>%
  add_xy_position(x = "conc")
bxp <- ggboxplot(data_aov, x = 'conc', y = 'GE', add = 'point')
bxp
bxp +
  stat_pvalue_manual(pwc) +
  labs(subtitle = get_test_label(res.aov, detailed = TRUE),
       caption = get_pwc_label(pwc))

data_aov <- data %>%
  gather(key = 'conc', value = 'GE', '0','1','2','3','4','5','6','7','8','9','10') %>%
  convert_as_factor(sheet_names) %>%
  filter(!is.na(GE))
bxp <- ggboxplot(data_aov, x = 'conc', y = 'GE', color = 'treatment', palette = 'jco')
bxp
data_aov %>%
  group_by(treatment, conc) %>%
  identify_outliers(GE)
normality_test <- data_aov %>%
  group_by(treatment, conc) %>%
  shapiro_test(GE)
normality_test
ggqqplot(data_aov, "GE", ggtheme = theme_bw()) +
  facet_grid(conc ~ treatment, labeller = "label_both")
res.aov <- anova_test(data = data_aov, dv = GE, wid = sheet_names, within = c(treatment, conc))
get_anova_table(res.aov)
