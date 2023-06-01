pacman::p_load(tidyverse, readr, rstatix, ggpubr)
data <- read_csv(here::here("data/2023-03-01_gene-data.csv"))

##example
library(datarium)
data("performance", package = "datarium")
performance <- performance %>%
  gather(key = 'time', value = 'score', t1, t2) %>%
  convert_as_factor(id, time)
bxp <- ggboxplot(performance,
                 x = 'gender',
                 y = 'score',
                 color = 'stress',
                 palette = 'jco',
                 facet.by = 'time')
bxp
#check assumptions
performance %>%
  group_by(gender, stress, time) %>%
  identify_outliers(score)
normality_test <- performance %>%
  group_by(gender, stress, time) %>%
  shapiro_test(score)
normality_test %>% arrange(p)
ggqqplot(performance, 'score', ggtheme = theme_bw()) +
  facet_grid(time ~ stress, labeller = "label_both")
homogeneity_test <- performance %>%
  group_by(time) %>%
  levene_test(score ~ gender*stress)
homogeneity_test %>% arrange(p)
#three-way mixed ANOVA
res.aov <- anova_test(data = performance,
                      dv = score,
                      wid = id,
                      within = time,
                      between = c(gender, stress))
get_anova_table(res.aov)
#post-hoc
# two-way interaction at each time levels
two.way <- performance %>%
  group_by(time) %>%
  anova_test(dv = score, wid = id, between = c(gender, stress))
two.way
# simple simple main effect
stress.effect <- performance %>%
  group_by(time, gender) %>%
  anova_test(dv = score, wid = id, between = stress)
stress.effect# %>% filter(time == "t2")
# simple simple pairwise comparisons
pwc <- performance %>%
  group_by(time, gender) %>%
  pairwise_t_test(score ~ stress, p.adjust.method = "bonferroni") %>%
  select(-p, -p.signif) # Remove details
pwc %>% filter(time == "t2", gender == "female")
# Visualization: box plots with p-values
pwc <- pwc %>% add_xy_position(x = "gender")
pwc.filtered <- pwc %>% filter(time == "t2", gender == "female")
bxp +
  stat_pvalue_manual(pwc.filtered, tip.length = 0, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.aov, detailed = TRUE),
    caption = get_pwc_label(pwc)
  )

#actual data
data_aov <- data %>%
  mutate(CL = `cell line`) %>%
  select(-`cell line`) %>%
  gather(key = "conc", value = "GE", '0','1','2','3','4','5','6','7','8','9','10') %>%
  convert_as_factor(sheet_names) %>%
  filter(!is.na(GE))
head(data_aov)
#visualisation
bxp <- ggboxplot(data_aov,
                 x = 'conc',
                 y = 'GE',
                 color = 'treatment',
                 palette = 'jco',
                 facet.by = 'CL')
bxp
#check assumptions
data_aov %>%
  group_by(CL, treatment, conc) %>%
  identify_outliers(GE)
normality_test <- data_aov %>%
  group_by('CL', treatment, conc) %>%
  shapiro_test(GE)
normality_test %>% arrange(p)
ggqqplot(data_aov, 'GE', ggtheme = theme_bw()) +
  facet_grid(conc ~ treatment, labeller = "label_both")
homogeneity_test <- data_aov %>%
  group_by(conc) %>%
  levene_test(GE ~ CL*treatment)
homogeneity_test %>% arrange(p)
#three-way mixed ANOVA
res.aov <- anova_test(data = data_aov,
                      dv = GE,
                      wid = sheet_names,
                      within = conc,
                      between = c(CL, treatment))
get_anova_table(res.aov)
#post-hoc
# two-way interaction at each time levels
two.way <- data_aov %>%
  group_by(CL) %>%
  anova_test(dv = GE, wid = sheet_names, between = c(conc, treatment))
two.way
# simple simple main effect
treatment.effect <- data_aov %>%
  group_by(CL, conc) %>%
  anova_test(dv = GE, wid = sheet_names, between = treatment) %>%
  mutate(conc = as.integer(conc)) %>%
  arrange(conc) %>%
  arrange(desc(CL)) %>%
  arrange(desc(`p<.05`))
treatment.effect# %>% filter(CL == "wild-type")
# simple simple pairwise comparisons
pwc <- data_aov %>%
  group_by(treatment, CL) %>%
  pairwise_t_test(GE ~ conc, p.adjust.method = "bonferroni") %>%
  select(-p, -p.signif) # Remove details
pwc %>% filter(CL == "wild-type") %>% arrange(p.adj.signif)
# Visualization: box plots with p-values
pwc <- pwc %>%
  add_xy_position(x = "conc") %>%
  mutate(group1 = as.integer(group1),
         group2 = as.integer(group2)) %>%
  arrange(p.adj.signif)
head(pwc)
pwc.filtered <- pwc %>% filter(CL == "wild-type")
head(pwc.filtered)
bxp2 <- ggboxplot(data_aov,
                 x = 'conc',
                 y = 'GE',
                 color = 'treatment',
                 palette = 'jco', #palette = "Spectral",
                 facet.by = 'CL')
bxp2
bxp2 +
  stat_pvalue_manual(pwc.filtered, tip.length = 0.005, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.aov, detailed = TRUE),
    caption = get_pwc_label(pwc)
  )



