library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

# Read the data
rent_data <- read_excel(
  "data/City_metrics_public_10-2026.xlsx"
)

# Select the university cities
selected_cities <- c(
  "Berlin",
  "Bonn",
  "Bremen",
  "Dresden",
  "Frankfurt am Main",
  "Hamburg",
  "Köln",
  "Leipzig",
  "München",
  "Münster"
)

# Keep annual and nominal observations
annual_rents <- rent_data |>
  filter(
    City %in% selected_cities,
    is.na(Quarter),
    is.na(Month),
    Inflation_adjusted == 0,
    Year >= 2015,
    Year <= 2025
  )

# Select 2025 data
rent_2025 <- annual_rents |>
  filter(Year == 2025) |>
  arrange(MED_PRICE_SQM)

# Create the visual
visual1 <- ggplot(
  rent_2025,
  aes(
    x = reorder(City, MED_PRICE_SQM),
    y = MED_PRICE_SQM
  )
) +
  geom_col(fill = "#1769AA") +
  geom_text(
    aes(label = paste0("€", round(MED_PRICE_SQM, 2))),
    hjust = -0.1,
    size = 3.5
  ) +
  coord_flip() +
  labs(
    title = "Students enter very different rental markets",
    subtitle = "Median asking rent in selected university cities, 2025",
    x = NULL,
    y = "Median asking rent per square metre",
    caption = "Source: GREIX rental market data"
  ) +
  scale_y_continuous(
    limits = c(0, 26),
    labels = label_number(prefix = "€")
  ) +
  theme_minimal()

# Display the visual
visual1

# Save the visual
ggsave(
  "figures/visual1_current_rents.png",
  visual1,
  width = 10,
  height = 6,
  dpi = 300
)

# Keep the starting and ending years
rent_change <- annual_rents |>
  filter(Year %in% c(2015, 2025)) |>
  select(City, Year, MED_PRICE_SQM) |>
  pivot_wider(
    names_from = Year,
    values_from = MED_PRICE_SQM,
    names_prefix = "rent_"
  ) |>
  mutate(
    growth = ((rent_2025 - rent_2015) / rent_2015) * 100
  )

# Arrange cities by rental growth
rent_growth <- rent_change |>
  arrange(growth)

# Create the visual
visual2 <- ggplot(
  rent_growth,
  aes(
    x = reorder(City, growth),
    y = growth
  )
) +
  geom_col(fill = "#E8672C") +
  geom_text(
    aes(label = paste0(round(growth, 0), "%")),
    hjust = -0.1,
    size = 3.5
  ) +
  coord_flip() +
  labs(
    title = "Some lower-cost cities are becoming expensive quickly",
    subtitle = "Growth in median asking rents, 2015 to 2025",
    x = NULL,
    y = "Rental growth",
    caption = "Source: GREIX rental market data"
  ) +
  scale_y_continuous(
    limits = c(0, 90),
    labels = label_percent(scale = 1)
  ) +
  theme_minimal()

# Display the visual
visual2

# Save the visual
ggsave(
  "figures/visual2_rental_growth.png",
  visual2,
  width = 10,
  height = 6,
  dpi = 300
)

# Create the scatter plot
visual3 <- ggplot(
  rent_change,
  aes(
    x = rent_2015,
    y = growth,
    label = City
  )
) +
  geom_point(
    colour = "#1769AA",
    size = 4
  ) +
  geom_text(
    vjust = -0.8,
    size = 3.2,
    check_overlap = TRUE
  ) +
  labs(
    title = "The map of lower-cost university cities is shifting",
    subtitle = "Starting rent level compared with rental growth",
    x = "Median asking rent in 2015",
    y = "Rental growth from 2015 to 2025",
    caption = "Source: GREIX rental market data"
  ) +
  scale_x_continuous(
    labels = label_number(prefix = "€")
  ) +
  scale_y_continuous(
    labels = label_percent(scale = 1)
  ) +
  theme_minimal()

# Display the visual
visual3

# Save the visual
ggsave(
  "figures/visual3_affordability_shift.png",
  visual3,
  width = 10,
  height = 6,
  dpi = 300
)