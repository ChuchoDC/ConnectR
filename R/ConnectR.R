library(readxl)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(scales)
library(pbapply)

#' Title
#'
#' @param file Name of the file
#' @param type Type of the file (.xlsx or .csv)
#' @param sheets Number of sheets to process
#' @param indices Indices to calculate
#' @param n_boot Number on bootstraps samples for resampling
#' @param dist_type distibution type: "histogram" or "density"
#'
#' @return an assessment of the biogeographic structuring of the bipartite network provided
#' @export
#'
#' @examples ConnectR("Aulopiformesdata.xlsx",".xlsx")
ConnectR <- function(file, type, sheets = "", indices = "", n_boot = 1000, dist_type = "density") {

  if (length(indices) == 0 || any(indices == "")) {
    indices <- c("BC", "AO", "AE", "NC")
  }
  if (length(sheets) == 0 || any(sheets == "")) {
    sheets <- NULL
  }

  calc_index <- function(df, indices) {
    df <- df %>% filter(rowSums(.) > 0)

    N <- nrow(df)
    L <- ncol(df)
    O <- sum(df, na.rm = TRUE)

    if (O == 0 && N == 0) {
      return(NULL)
    }

    idx <- list()

    if ("BC" %in% indices) idx$BC <- (O - N) / (L * N - N)
    if ("AO" %in% indices) idx$AO <- O / L
    if ("AE" %in% indices) idx$AE <- sum(rowSums(df) == 1) / N
    if ("NC" %in% indices) {
      connections <- sum(df)
      idx$NC <- connections / (N * (N - 1))
    }

    return(as.data.frame(idx))
  }

  if (type == "excel") {
    sheet_names <- excel_sheets(file)
    selected_sheets <- if (length(sheets) > 0) sheets else 1:length(sheet_names)
    data_list <- lapply(selected_sheets, function(i) {
      df <- read_excel(file, sheet = i)
      list(df = df %>% select(where(is.numeric)), sheet_name = sheet_names[i])
    })
  } else if (type == "csv") {
    df <- read.csv(file)
    data_list <- list(list(df = df %>% select(where(is.numeric)), sheet_name = "CSV"))
  } else {
    stop("Unsupported file type. Use 'excel' or 'csv'.")
  }

  omitted_sheets <- character(0)

  results <- lapply(data_list, function(data) {
    idx <- calc_index(data$df, indices)
    if (is.null(idx)) {
      omitted_sheets <<- c(omitted_sheets, data$sheet_name)
      return(NULL)
    } else {
      return(cbind(idx, Sheet = data$sheet_name))
    }
  })

  if (length(omitted_sheets) > 0) {
    message("Warning: The following sheets were omitted due to O = 0 and N = 0: ", paste(omitted_sheets, collapse = ", "))
  }

  combined_results <- do.call(rbind, results)
  combined_results <- combined_results[complete.cases(combined_results), ]

  bootstrap_results <- list()
  for (idx in indices) {
    bootstrap_vals <- pblapply(data_list, function(data) {
      sheet_name <- data$sheet_name
      bootstrap_samples <- numeric(n_boot)
      for (b in 1:n_boot) {
        sample_data <- data$df[sample(nrow(data$df), replace = TRUE), ]
        idx_val <- calc_index(sample_data, indices)
        if (is.null(idx_val)) {
          bootstrap_samples[b] <- NA
        } else {
          bootstrap_samples[b] <- mean(idx_val[[idx]], na.rm = TRUE)
        }
      }
      data.frame(Value = bootstrap_samples, Sheet = sheet_name, Index = idx)
    })
    bootstrap_results[[idx]] <- do.call(rbind, bootstrap_vals)
  }

  calc_bins <- function(data) {
    n <- length(data)
    if (n > 1) {
      bins <- ceiling(log2(n) + 1)
    } else {
      bins <- 10
    }
    return(bins)
  }

  plots <- list()
  for (idx in indices) {
    plot_data <- bootstrap_results[[idx]] %>%
      filter(!is.na(Value) & is.finite(Value))

    bins <- calc_bins(plot_data$Value)

    colors <- scales::seq_gradient_pal("blue", "red", "Lab")(seq(0, 1, length.out = length(unique(plot_data$Sheet))))

    plot <- ggplot(plot_data, aes(x = Value, fill = Sheet))

    if (dist_type == "histogram") {
      plot <- plot + geom_histogram(bins = bins, alpha = 0.6, position = "identity", color = "black")
    } else if (dist_type == "density") {
      plot <- plot + geom_density(alpha = 0.4, color = "black")
    } else {
      stop("Invalid distribution type. Use 'histogram' or 'density'.")
    }

    plot <- plot +
      scale_fill_manual(values = colors) +
      labs(title = paste("Bootstrapped", idx), x = idx, y = "Density", fill = "Sheets") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))

    plots[[idx]] <- plot
  }

  num_plots <- length(plots)
  rows <- ceiling(sqrt(num_plots))
  cols <- ceiling(num_plots / rows)
  do.call(grid.arrange, c(plots, ncol = cols))

  return(combined_results)
}
