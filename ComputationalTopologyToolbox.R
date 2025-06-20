---
  title: "Computational Topology"
subtitle: "Toolbox"
author:
  - name: Thomas Reinke
affiliation: 
  - name: Baylor University
department: Statistical Science
# city: Waco
# state: TX
# country: US
url: https://www.baylor.edu
# email: thomas_reinke1@baylor.edu
date: today
date-format: "MMMM D, YYYY"
format: 
  revealjs:
  theme: 
  - quarto-assets/baylor-theme.scss
smaller: false
scrollable: false
show-slide-number: all
toc: false
toc-depth: 1
preview-links: true
slide-number: c/t
multiplex: true
embed-resources: true
auto-animate: true
footer: "Thomas Reinke"
bibliography: references.bibtex
lightbox:
  match: auto
effect: fade
desc-position: bottom
loop: true
logo: "quarto-assets/baylor.png"
license: "CC BY-NC"
copyright: 
  holder: Thomas Reinke
year: 2025
editor: 
  markdown: 
  wrap: 72
---
  
  ```{r, setup}
#| include: false
#| message: false
library(knitr)
library(tidyverse)
library(conflicted)
library(janitor)
library(ggtda)
# library(TDAvis)
library(patchwork)
library(gganimate)
library(ggforce)
library(simplextree) 
library(gifski)
library(magick)  
library(ripserr)
library(BayesTDA)
library(TDAstats)
library(mvtnorm)
library(kableExtra)
library(plotly)
conflicted::conflict_prefer("filter", "dplyr")
conflicted::conflict_prefer("select", "dplyr")
conflicted::conflicts_prefer(ggtda::geom_simplicial_complex)
conflicted::conflicts_prefer(plotly::layout)
knitr::opts_chunk$set(
  comment = "#>",
  message = FALSE,
  warning = FALSE,
  cache = TRUE,
  echo = FALSE,
  tidy.opts = list(width.cutoff = 100),
  tidy = FALSE,
  fig.align = "center"
)
ggplot2::theme_set(ggplot2::theme_minimal())
ggplot2::theme_update(panel.grid.minor = ggplot2::element_blank())

#------------------------------------------------------------#
```

::: {.content-hidden}
$$
  {{< include quarto-assets/_macros.tex >}}
$$
  :::
  
  # Contents
  
  1.  [Introduction](#sec-intro)
    1.  [Background](#sec-background)
      1.  [Bayesian Framework](#sec-bayes)
        1.  [Worked Example](#sec-example)
          1.  [Classification](#sec-classification)
            1.  [References](#sec-bib)
              