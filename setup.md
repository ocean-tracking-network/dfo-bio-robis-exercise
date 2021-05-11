---
title: Setup
---

Run the following package installations to ensure you're ready to use `robis`:

```{r}
install.packages("remotes")  # update this if you have already installed it.
remotes::install_github("iobis/robis")
install.packages("readr")
install.packages("httr")
install.packages("dplyr")
install.packages("DT")
install.packages("stringr")
install.packages("sf")
install.packages("ggplot2")
install.packages("leaflet")
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages('spocc')  # bonus content
install.packages('mapr')
install.packages('scrubr')
```


We can test the success of the install step by loading the packages

```{r}
library(dplyr)
library(leaflet)
library(robis)
library(spocc)
```

{% include links.md %}
