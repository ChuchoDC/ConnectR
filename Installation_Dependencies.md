# ConnectR: Installation and Dependencies

---

## **Dependencies**

To run the `ConnectR` function, the following R packages are required:

- **readxl**: For reading Excel files.  
- **dplyr**: For data manipulation and processing.  
- **ggplot2**: For creating visualizations.  
- **gridExtra**: For arranging multiple plots in a grid.  
- **scales**: For color scales and other graphical settings.  
- **pbapply**: For parallelized operations during the bootstrap process.

### **Dependencies Installation**
Before using `ConnectR`, you need to install these packages if they are not already installed. 
You can install them using the following command:

```R
install.packages(c("readxl", "dplyr", "ggplot2", "gridExtra", "scales", "pbapply"))
```

---

## **Output Example**

The `ConnectR` function returns a data frame with the calculated indices for each sheet in the input data. Here's an example of how the output might look:

### **Sample Output**

```R
  BC        AO        AE        NC      Sheet
1  0.25     0.75      0.50     0.30     Sheet1
2  0.35     0.70      0.45     0.32     Sheet2
3  0.40     0.65      0.60     0.28     Sheet3
```
### **Columns Explained**

- **BC:** Biogeographical Connectivity Index
  
- **AO:** Average Occurrences

- **AE:** Average Endemics

- **NC:** Network Clustering Index

- **Sheet:** Name of the sheet from which the data is derived.

In addition to the table of results, the function generates visualizations (histograms or density plots) showing the distribution of the bootstrapped values for each index.

Each bootstrapped index will have its own plot, making it easy to visualize the variability and stability of the indices over multiple iterations. The visualizations will be arranged dynamically based on the number of indices selected.
