# ConnectR

<!-- README.md is generated from README.Rmd. Please edit that file -->
<br> <img src="images\icono_connectR.png" align="left" width="155">
=======

<br><br><br><br>


<br>
ConnectR

This is a software fully developed in R, which implements indexes
proposed by [Sidor et al. (2013)](https://doi.org/10.1073/pnas.1302323110).
Such indexes include:  **Biogeographic Connectedness**, **Network Cluserting**,
**Average Ocurrences**, and **Average Endemics".
The final user only need to create the input into the correct format, indicate
which index, if not all of them, will be calculated, and determine the amount of
ages (number of pages) to assess. 

The software will carry out parametric sampling of the indexes and plot them.
These analyses can complement biogeographical studies based exclusively on
geographical ocurrences, with the main advantage of not requiring phylogenies.  

In order for this library to work correctly, the dependencies required are:
`readxl`
`dplyr`
`ggplot2`
`gridExtra`
`scales`
`pbapply`

**Important to notice**
The software is in its final stage of development. 
Authors are testing it with empirical and simulated datasets to ensure its correct operation.   


<br><br>
## **Authors**:
[Angel Angeles Cortés](https://github.com/4ngel19)  
email:
<a href="mailto:angel_10@ciencias.unam.mx" class="email">angel_10@ciencias.unam.mx</a>

[Dr. Jesús Alberto Díaz-Cruz](https://github.com/ChuchoDC)  
email:
<a href="mailto:vertebrata.j@ciencias.unam.mx" class="email">vertebrata.j@ciencias.unam.mx</a>
