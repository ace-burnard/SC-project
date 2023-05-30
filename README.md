# README

## Data provided on 1st March 2023
-   Data from Karl in "raw-data/2023-03-01_gene-data.xlsx"
-   Cleaned using file "R/2023-03-01_process-data.R", and saved in "data/2023-03-01_gene-data.csv"
-   Summary plots made using code "R/2023-03-02_summary-plots.R" on data "data/2023-03-01_gene-data.csv"
-   Summary plots saved in "figures/conc-ge\_[grouping]\_[plot type].svg", where [grouping] is one of 'all-grouping', 'cell-line', 'treatment'; and [plot type] is either 'datapoints' or 'lm'
-   Fitting models in code "R/2023-03-07_lm-fitting.R" on data in "data/2023-03-01_gene-data.csv"
-   Implementing repeated measures ANOVA and mixed measures ANOVA on the data in "data/2023-03-01_gene-data.csv" in files "R/2023-03-19_repeated-measures-ANOVA.R" and "R/2023-03-19_mixed-measures-ANOVA.R"
-   Some more EDA plots in "R/2023-03-20_EDA-plots.R" of the data in "data/2023-03-01_gene-data.csv"
-   A tidied up version of "R/2023-03-19_mixed-measures-ANOVA.R" in "R/2023-03-21_mixed--ANOVA.Rmd"

## Redo graph (original sent 3 April 2023)
-   the original graph is in "resources/2023-04-03_gene_plot.pdf"
-   code to make plot in "R/2023-04-03_plot-for-Karl_diff-font.Rmd"

## Email re grant/sample size (sent 1 May 2023)
-   code to calculate sample size in "R/2023-05-02_sample-size-for-grant.Rmd"

## IMRaD report
-   fitting models to predict gene expression based on growth factor concentration, treatment, and cell line, and looking at a random effect term for gene line
-   writing report on the data and the fitted models
-   selected a random intercept model (using lmer function from lme4 package)
