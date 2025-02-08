<h1> 
<a href="https://chuchodc.github.io/ConnectR/">ConnectR</a>
</h1>
---

# ConnectR: User Manual

ConnectR is an R function designed to calculate biogeographic connectivity indices with bootstrap sampling. It processes data from Excel or CSV files and generates visualizations of the index distributions.


## **Function Overview**

### **Function Signature**
```r
ConnectR(file, type, sheets = "", indices = "", n_boot = 1000, dist_type = "density")
```

## **Arguments**

| Argument    | Type                 | Default        | Description                                                                                 |
|-------------|----------------------|----------------|---------------------------------------------------------------------------------------------|
| `file`      | `character`          | **Required**   | File path to the Excel (`.xlsx`) or CSV (`.csv`) data file.                                 |
| `type`      | `character`          | **Required**   | File type: `"excel"` or `"csv"`.                                                           |
| `sheets`    | `character` or `NULL`| `""`           | Names or indices of sheets to process. If `""`, all sheets will be processed.              |
| `indices`   | `character`          | `""`           | Indices to calculate: `BC`, `AO`, `AE`, `NC`. If `""`, all indices will be calculated.     |
| `n_boot`    | `integer`            | `1000`         | Number of bootstrap samples for resampling.                                                |
| `dist_type` | `character`          | `"density"`    | Distribution type for visualization: `"density"` or `"histogram"`.                         |

---



## **Input Data Format**

The input file must be either an Excel file (`.xlsx`) or a CSV file (`.csv`) and should adhere to the following structure:  
- **Rows**: Represent taxon/species.  
- **Columns**: Represent localities.  
- **Cell values**: Use `0` for absence and `1` for taxon presence in localities.  

### Example:
|         | Locality 1 | Locality 2 | Locality 3 | ... | Locality n |
|---------|-----------|-----------|-----------|-------|---|
| Taxon 1 | 1         | 0         | 1         |...    |0  |
| Taxon 2 | 0         | 1         | 1         |...    |1  | 
|     ⋮   |  ⋮         |  ⋮        |   ⋮        |  ⋱   | ⋮  |
| Taxon m | 0         | 0         |  1        |  ...  | 0  |

---




## **Output**

The output is a combined data frame containing the calculated indices for all sheets processed. It includes:  
- Calculated indices (`BC`, `AO`, `AE`, `NC`).  
- Sheet names (if applicable).  

---

## **Examples**

### Example 1: Process all sheets in an Excel file
```R
result <- ConnectR(file = "data.xlsx", type = "excel")
```
###Example 2: Process selected sheets and specific indices
```R
result <- ConnectR(file = "data.xlsx", type = "excel", sheets = c(1, 2), indices = c("BC", "AO"))
```
###Example 3: Example 3: Use CSV file and customize bootstrap settings
```R
result <- ConnectR(file = "data.csv", type = "csv", n_boot = 500, dist_type = "histogram")
```

**¡Important!** if no index is declared and the argument is not included such as in Example 1. All indixes will be calculated. 


## **Visualization Customization**

You can customize the visual representation of the bootstrapped indices by specifying the type of distribution plot you want to generate.  

### **Available Options**
- **Density Plot (`"density"`)**: Displays a smooth curve representing the density of bootstrapped values.  
- **Histogram (`"histogram"`)**: Displays a bar chart showing the frequency distribution of bootstrapped values.

### **Example Usage**
Specify the `dist_type` argument to choose your desired visualization type:
```R
result <- ConnectR(file = "data.xlsx", type = "excel", dist_type = "histogram")
```
### **Customization Notes**

Visualizations are automatically scaled to fit all selected indices.

- Each index will have its own distribution plot, and they are arranged dynamically based on the number of indices selected.
  
- For easier interpretation, plots include axis labels, legends, and titles.

## **Warnings**

When running the analysis, there are several cases that may trigger warnings. These are important to address to ensure accurate results.

### **Empty Sheets**
If a sheet has no presence (`O = 0`) or no taxa (`N = 0`), it will be skipped in the analysis. A warning message will notify you about the skipped sheets.  


### **Input Validation**
Ensure your input file follows the correct format:
- Excel files should have rows representing taxa/species and columns representing localities, with `1` indicating presence and `0` indicating absence.
- CSV files should follow the same structure.

If the input file does not match the expected format, an error or warning may occur.

### **Bootstrap Settings**
- High values of `n_boot` can result in long processing times. If you're running on large datasets, consider using a smaller value for `n_boot` to reduce computational time.
- If you experience long run times, try reducing the number of bootstrap iterations or optimize your input data.

---

By paying attention to these warnings, you can ensure that the analysis runs smoothly and that the results are reliable.
