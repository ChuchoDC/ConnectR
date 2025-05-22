#' Performs Biogeographical Bootstrap Analysis with Visualization
#'
#' This function processes a biogeographical dataset provided as a .csv or .xlsx file and
#' calculates connectivity-related indices including Biogeographical Connectiveness (BC),
#' Average Occurrences (AO), Average Endemics (AE), and Network Clustering (NC).
#' It applies parametric bootstrap sampling to each selected index and presents the results
#' in an interactive dashboard, accompanied by distribution plots and timing information.
#'
#' The function also generates a final graphical summary showing the arrangement of
#' the bootstrap distribution plots for all evaluated indices.
#'
#' @param file Path to the file to analyze. Can be a .xlsx or .csv file.
#' @param type Type of file: either "excel" or "csv".
#' @param sheets Sheet(s) to analyze (for Excel files). Use a character vector with sheet
#'   names or a numeric vector with sheet indices. Ignored for CSV files.
#' @param indices Biogeographical indices to calculate. Options include "BC", "AO", "AE", and "NC".
#'   Use "" to compute all.
#' @param n_boot Number of samples to generate using parametric bootstrap. Default is 1000.
#' @param dist_type Type of plot to display the bootstrap distributions. Options: "density" or "histogram".
#'   Default is "density".
#' @param color Color palette range used in plots. Default is c("blue", "red").
#'
#' @return A dashboard visualizing the selected biogeographical indices and their bootstrap
#'   distributions, along with summary statistics and a timer showing execution time.
#' @examples
#' connectr(file = "Aulopiformes.xlsx",
#'          type = "excel",
#'          sheets = c(2),
#'          indices = c("BC", "AE", "NC"),
#'          n_boot = 3000,
#'          color = c("green", "yellow"))
#'
#' connectr(file = "BiogeographyData.csv",
#'          type = "csv",
#'          indices = "",
#'          n_boot = 1000)
#'
#' @expor

connectr <- function(file, type, sheets = "", indices = "", n_boot = 1000,
                     dist_type = "density", color = c("blue", "red")) {

  utils::globalVariables(c("Sheet", "Value"))

  if (length(color) != 2) {
    stop("El argumento 'color' debe ser un vector de dos colores, por ejemplo: color = c('blue', 'red')")
  }

  if (length(indices) == 0 || any(indices == "")) {
    indices <- c("BC", "AO", "AE", "NC")
  }
  if (length(sheets) == 0 || any(sheets == "")) {
    sheets <- NULL
  }


  calc_index <- function(df, indices) {

    df <- df[base::rowSums(df) > 0, ]

    N <- nrow(df)
    L <- ncol(df)
    O <- sum(df, na.rm = TRUE)

    if (O == 0 && N == 0) {
      return(NULL)
    }

    idx <- list()

    if ("BC" %in% indices) idx$BC <- (O - N) / (L * N - N)
    if ("AO" %in% indices) idx$AO <- O / L
    if ("AE" %in% indices) idx$AE <- sum(base::rowSums(df) == 1) / N
    if ("NC" %in% indices) {
      connections <- sum(df)
      idx$NC <- connections / (N * (N - 1))
    }

    return(as.data.frame(idx))
  }


  if (type == "excel") {
    sheet_names <- readxl::excel_sheets(file)
    selected_sheets <- if (length(sheets) > 0) sheets else 1:length(sheet_names)
    data_list <- lapply(selected_sheets, function(i) {
      df <- readxl::read_excel(file, sheet = i)
      list(df = dplyr::select(df, where(is.numeric)), sheet_name = sheet_names[i])
    })
  } else if (type == "csv") {
    df <- utils::read.csv(file)
    data_list <- list(list(df = dplyr::select(df, where(is.numeric)), sheet_name = "CSV"))
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
    cat("Warning: The following sheets were omitted due to O = 0 and N = 0: ", paste(omitted_sheets, collapse = ", "), "\n")
  }


  combined_results <- do.call(rbind, results)
  combined_results <- combined_results[complete.cases(combined_results), ]


  bootstrap_results <- list()
  for (idx in indices) {
    bootstrap_vals <- pbapply::pblapply(data_list, function(data) {
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

  if ("BC" %in% indices) {
    bc_values <- combined_results[["BC"]]
    bc_sheets <- combined_results[["Sheet"]]

    bc_values_rounded <- round(bc_values, 1)

    similar_indices <- list()

    for (i in 1:(length(bc_values_rounded) - 1)) {
      for (j in (i + 1):length(bc_values_rounded)) {
        if (bc_values_rounded[i] == bc_values_rounded[j]) {
          similar_indices <- c(similar_indices,
                               paste(bc_sheets[i],
                                     " and ",
                                     bc_sheets[j]))
        }
      }
    }

    if (length(similar_indices) > 0) {
      cat("There are similar values for BC coeficient in the sheets:\n",
          paste(similar_indices, collapse = "\n"),". This doesn't mean that they share the same localities. \n")
    }
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


  color_fun <- scales::seq_gradient_pal(color[1], color[2], "Lab")


  plots <- lapply(indices, function(idx) {
    plot_data <- dplyr::filter(bootstrap_results[[idx]], !is.na(Value) & is.finite(Value))

    bins <- calc_bins(plot_data$Value)

    colors <- color_fun(seq(0, 1, length.out = length(unique(plot_data$Sheet))))

    ggplot2::ggplot(plot_data, ggplot2::aes(x = Value, fill = Sheet)) +
      { if (dist_type == "histogram")
        ggplot2::geom_histogram(bins = bins, alpha = 0.6, position = "identity", color = "black")
        else
          ggplot2::geom_density(alpha = 0.4, color = "black")
      } +
      ggplot2::scale_fill_manual(values = colors) +
      ggplot2::labs(title = paste("Bootstrapped", idx), x = idx, y = "Density", fill = "Sheets") +
      ggplot2::theme_minimal() +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  })


  num_plots <- length(plots)
  rows <- ceiling(sqrt(num_plots))
  cols <- ceiling(num_plots / rows)


  gridExtra::grid.arrange(grobs = plots, ncol = cols)

  return(combined_results)
}
