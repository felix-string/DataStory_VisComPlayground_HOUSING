# Student Housing Affordability Gap in Germany

## A visual story of rental pressure across German university cities

This repository contains the report, presentation, data, code, and visualisations developed for the **Visual Communication and Data Storytelling** module.

The project was developed by:

- **Felix Sandile Thwala**
- **Sibahle Mabhuda**

## Project background

Choosing a university is also a housing decision. Although students study within the same German higher-education system, students enter local housing markets with very different asking rents and rental growth patterns.

The project investigates how rental-market conditions differ across selected German university cities. It also examines whether cities that were previously relatively affordable are experiencing faster rental growth.

The private rental-market analysis is combined with national student housing information to show how wider market conditions may affect students, particularly because dedicated student accommodation houses only part of the student population.

## Central question

**How is student housing pressure changing across selected German university cities?**

The project addresses three supporting questions:

1. How large is the current asking-rent gap between selected university cities?
2. Which lower-cost university cities are experiencing the fastest rental growth?
3. How many students in Germany have access to dedicated student accommodation?

## Main story

Students enter sharply different private rental markets depending on where they study. München remains the most expensive city in the selected sample, while some previously cheaper cities, including Leipzig and Bremen, have experienced substantial rental growth.

These patterns suggest that the map of lower-cost university cities is shifting. However, the shift is not uniform because cities such as Dresden remain comparatively less expensive and have recorded slower growth.

The student housing challenge is made more important by the limited reach of dedicated student accommodation. Many students depend on other housing arrangements and may therefore be affected by conditions in the wider rental market.

## Data sources

### GREIX rental-market data

The project uses data from the **German Real Estate Index, known as GREIX**, to examine rental conditions across selected German cities.

The main variables include:

- City
- Year, quarter, and month
- Median asking rent per square metre
- Average asking rent per square metre
- Rental-price index
- Inflation-adjusted rental-price index
- Lower and upper asking-rent percentiles

The main city comparison uses complete annual nominal observations from **2015 to 2025**.

### EUROSTUDENT 8

The project also uses **EUROSTUDENT 8 Topic E: Housing Situation** to provide student-specific context.

The data describe the proportion of students in Germany who live:

- With parents
- In dedicated student accommodation
- With a partner or children
- With other people
- Alone

The EUROSTUDENT data are national and are therefore not merged directly with individual German cities.

## Selected university cities

The main analysis focuses on ten German university cities:

- Berlin
- Bonn
- Bremen
- Dresden
- Frankfurt am Main
- Hamburg
- Köln
- Leipzig
- München
- Münster

These cities provide a mixture of traditionally expensive markets, medium-cost cities, and historically lower-cost alternatives.

## Main visual story

The presentation follows a linear story:

1. **The current rental gap**  
   Median asking rents are compared across the selected university cities.

2. **The monthly meaning of the gap**  
   The difference is illustrated using a standardised 30-square-metre apartment.

3. **Rental growth over time**  
   Changes in median asking rent between 2015 and 2025 are compared.

4. **Different city pathways**  
   Starting asking rents are compared with subsequent rental growth.

5. **The role of inflation**  
   Nominal and inflation-adjusted rental indices are compared.

6. **Student housing exposure**  
   EUROSTUDENT data show the housing arrangements used by students in Germany.

7. **The combined pressure**  
   Rising private-market rents are considered alongside the limited reach of dedicated student accommodation.

## Repository contents

- `index.qmd` contains the complete HTML report.
- `Presentation.qmd` contains the Revealjs presentation.
- `StudentHousingVisuals.R` contains the reproducible R analysis and visualisation code.
- `data/` contains the GREIX and EUROSTUDENT datasets used in the analysis.
- `figures/` contains exported visualisations.
- `_quarto.yml` contains the Quarto website configuration.
- `_site/` contains the rendered website and presentation.
- `Visual Communication and Data Storytelling.json` contains the bibliography used by the report.

## Main outputs

The project produces:

- A Quarto HTML report
- A Quarto Revealjs presentation
- Reproducible R visualisations
- Cleaned analytical datasets
- Supporting tables and figures
- A spatial map of selected university cities

## Reproducing the project

The project requires:

- Quarto
- R
- RStudio, Visual Studio Code, or Positron
- The required R packages

The main R packages are:

- tidyverse
- readxl
- scales
- ggrepel
- sf
- giscoR

After opening the repository, render the complete project from the terminal by entering `quarto render`.

To preview only the presentation, enter `quarto preview Presentation.qmd`.

To preview only the report, enter `quarto preview index.qmd`.

## Important interpretation

The GREIX data represent advertised asking rents in the wider private rental market. The analysis therefore uses asking rents as an indicator of the housing pressure students may encounter when searching for private accommodation. The project does not calculate a complete city-level affordability ratio because city-level student income data are not included.

## Main limitation

The GREIX and EUROSTUDENT datasets describe different geographical levels. GREIX provides city-level rental-market data, while EUROSTUDENT provides national student housing information for Germany. The datasets are connected through the project narrative but are not directly merged at the city level.

## Main insight

Students enter sharply different private rental markets, and rapid rent growth in some previously cheaper cities means that lower-cost university alternatives are becoming less secure. Dedicated student accommodation reaches only a minority of students, making conditions in the wider rental market an important part of the student housing story.
