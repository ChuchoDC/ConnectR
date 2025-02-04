<!-- README.md is generated from README.Rmd. Please edit that file -->
<div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
  <img src="images/icono_connectR.png" width="130">
<a href="https://github.com/ChuchoDC/ConnectR/blob/main/README.md">
    <img src="https://img.shields.io/badge/See%20in%20English-%23FFFFFF?style=for-the-badge&logoColor=white&color=blue" alt="See in English">
</a>
</div>

# **ConnectR** 

<br>

Este es un paquete completamente desarrollado en R, el cual calcula los índices propuestos por [Sidor et al. (2013)](https://doi.org/10.1073/pnas.1302323110).

Estos índices incluyen:<br>
**Biogeographic Connectedness**, **Network Cluserting**, **Average Ocurrences**, y **Average Endemics**.

El usuario final solo necesitará crear el archivo de entrada en el formato correcto,
indicar qué ídice, si no todos ellos, será calcualado y especificar el número de edades (número de páginas) para evaluar.

El programa arroajára el índice deseado para cada temporalidad indicada, al tiempo que también realizará el correspondiente remuestreo paramétrico y lo graficará.
Estos cálculos son complementarios a visualizaciones de redes complejas que pueden ser creados en [Gephi](https://gephi.org/) o con [igraph R package](https://igraph.org/).


Este tipo de análisis son relevantes porque nos permiten realizar estudios biogeográficos de fauna fósil usando exclusivamente sus ocurrencias geográficas. Además de la documentación, [ConnectR](https://github.com/ChuchoDC/ConnectR) incluye un conjunto de datos empíricos de peces fósiles del Cretácico, Aulopiformes, un grupo ampliamente distribuido con un registro fósil numeroso y bien conocido. 

Para que el paquete funcion correctamente, las dependencias necesarias son<br>
`readxl`<br>
`dplyr` <br>
`ggplot2`<br>
`gridExtra`<br>
`scales`<br>
`pbapply`<br>

## Contentenido

- [Guía de instalación y requisistos](Installation_Dependencies.md)
- [Documentación](Documentation.md)
- [Example de uso (En construcción)]() 


**Importante**<br>
El paquete se encuentra en su etapa final de desarrollo.
Los autores están evaluándolo con datos empíricos y simulados para asegurar su funcionamiento correcto. 

The software is in its final stage of development. 
Authors are testing it with empirical and simulated datasets to ensure its correct operation.   
<br>
## **Autores**:
[Angel Angeles Cortés](https://github.com/4ngel19)  
email:
<a href="mailto:angel_10@ciencias.unam.mx" class="email">angel_10@ciencias.unam.mx</a>

[Dr. Jesús Alberto Díaz-Cruz](https://github.com/ChuchoDC)  
email:
<a href="mailto:vertebrata.j@ciencias.unam.mx" class="email">vertebrata.j@ciencias.unam.mx</a>

