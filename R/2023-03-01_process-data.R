pacman::p_load(tidyverse, readxl)
path <- here::here("raw-data/2023-03-01_gene-data.xlsx")

data_init <- path %>%
  excel_sheets() %>%
  set_names() %>%
  map(read_excel, path = path, skip = 4, n_max = 11)
data_info <- path %>%
  excel_sheets() %>%
  set_names() %>%
  map(read_excel, path = path, n_max = 2)

type_row <- c()
factor_row <- c()
name_row <- c()
all_opts <- c()
for (i in 1:length(data_info)) {
  all_info <- c()
  curr_data <- enframe(data_info[i])
  name_row <- append(name_row, curr_data$name)
  cols <- colnames(curr_data$value[[1]])
  for (c in cols) {
    all_opts <- append(all_opts, c)
    all_info <- append(all_info, c)
  }
  new_data <- curr_data$value[[1]]
  if (length(new_data[[1]]) > 0) {
    all_opts <- append(all_opts, new_data[[1]])
    all_info <- append(all_info, new_data[[1]])
  }

  curr_type <- c()
  curr_factor <- c()
  for (info in all_info) {
    if (str_detect(info, "d-type")) {
      curr_type <- append(curr_type, "wild-type")
    } else {
      if (str_detect(info, "WT")) {
        curr_type <- append(curr_type, "wild-type")
      } else {
        if (str_detect(info, "type")) {
          curr_type <- append(curr_type, "cell-type 101")
        }
      }
    }
  }
  for (info in all_info) {
    if (str_detect(str_to_lower(info), "placebo")) {
      curr_factor <- append(curr_factor, "placebo")
    } else {
      if (str_detect(info, "factor")) {
        curr_factor <- append(curr_factor, "activating factor 42")
      }
    }
  }
  type_row <- append(type_row, curr_type[1])
  factor_row <- append(factor_row, curr_factor[1])
}

data <- data.frame(sheet_names = name_row)
line_col <- c()
for (i in 1:8) {
  line_col <- append(line_col, type_row[i])
}
data["cell line"] <- line_col
treat_col <- c()
for (i in 1:8) {
  treat_col <- append(treat_col, factor_row[i])
}
data["treatment"] <- treat_col
for (conc in 0:10) {
  curr_col <- c()
  for (i in 1:8) {
    curr_data <- enframe(data_init[i])
    curr_name <- curr_data$name
    curr_data <- curr_data$value
    col_names <- colnames(curr_data[[1]])
    last_col <- col_names[length(curr_data[[1]])]
    for (c in 1:length(curr_data[[1]])) {
      c_col <- curr_data[[1]][c]
      if (colnames(c_col) == last_col) {
        ge_col <- c_col
      }
    }
    curr_col <- append(curr_col, ge_col[[1]][conc+1])
  }
  data[as.character(conc)] <- curr_col
}

data["5"] <- na_if(data["5"], -99.00)

print(data)

save_path <- here::here("data/2023-03-01_gene-data.csv")
write_csv(data, save_path)
