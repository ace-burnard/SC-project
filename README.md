# README

## Powerpoint slides (due 24 March 2023)
- The raw data (provided by Karl on 1 March 2023) is in "raw-data/2023-03-01_gene-data.xlsx". Each sheet of the file is a different gene line. Each sheet has a cell line (wild-type or cell-type 101) and treatment (placebo or activating factor 42) specified, as well as the gene expression for each concentration of the growth factor (concentration in mg/ml).
- The raw data was cleaned using the code in "R/2023-03-01_process-data.R" and saved as the file "data/2023-03-01_gene-data.csv".
- Some summary plots of the data were made using the code in "R/2023-03-02_summary-plots.R" and saved in the "figures" folder, with the file name format "conc-ge\_[grouping]\_[plot type].svg", where [grouping] is one of 'all-grouping', 'cell-line', 'treatment'; and [plot type] is either 'datapoints' or 'lm'.
- Some models are fitted (using `lm`) in "R/2023-03-07_lm-fitting.R"
- Repeated measures and mixed measures ANOVAs are implemented in "R/2023-03-19_repeated-measures-ANOVA.R" and "R/2023-03-19_mixed-measures-ANOVA.R", to test the significance of predictors on gene expression.
- A tidied up version of the mixed measures ANOVA code is in "R/2023-03-21_mixed--ANOVA.Rmd".
- Some more EDA plots of the data are plotted in "R/2023-03-20_EDA-plots.R".
- The Powerpoint slides are in the files "2023-03-21_slides-for-Karl.pptx"" and "2023-03-24_slides.pptx".

## Graph (due 6 April 2023)
- The original graph sent by Karl (email on 3 April 2023) is in "resources/2023-04-03_gene_plot.pdf".
- The feature to be changed is the font (change to Times New Roman font), and the new graph should be a 9in x 6in file with a resolution of 500 dpi.
- The new graph is plotted using the code in "R/2023-04-03_plot-for-Karl_diff-font.Rmd", and saved in the "figures" folder with the file name "2023-04-03_plot.tiff".

## Sample size (due 5 May 2023)
- Email sent by Karl (on 1 May 2023), requesting the sample size required for a linear regression of gene expression with five predictors, where power is $90\%$, significance level is $0.05$ and previous research shows that $R^{2}=0.1$. The five predictors are:
  - concentration
  - cell age
  - treatment (two levels)
  - cell type (two levels)
  - media (two levels)
- The code used to find the necessary sample size is in "R/2023-05-02_sample-size-for-grant.Rmd".

## IMRaD report (due 26 May 2023)
- Requested a report on a predictive model of gene expression (email on 8 May 2023).
- The predictors investigated are growth factor concentration, treatment and cell line, as well as investigating the effect of a random intercept for gene line.
- The report is in the folder "IMRaD report", as is the bibliography file for the report.
