library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# 1. Load the GREIX city metrics data (using exact column names)
greix_data <- read_excel("data/City_Metrics_rents_sales-Mietpreis-Transaktionspreisindex.xlsx")

# 2. Load the E8 housing data and extract the Germany (DE) context
e8_agg <- read_excel("data/E8_topic_E__Housing_situation.xlsx", sheet = "housing_form_aggregated_all", skip = 3)

de_context_long <- e8_agg %>%
  filter(FG == "all_students", FGI == "all", I == "accom_aggregated") %>%
  select(indicator_item = II, DE) %>%
  mutate(
    country_iso2 = "DE",
    DE = as.numeric(DE)
  )

de_context_wide <- de_context_long %>%
  pivot_wider(
    names_from = indicator_item,
    values_from = DE,
    names_prefix = "de_share_"
  ) %>%
  rename(
    de_share_parents = de_share_1,
    de_share_student_accom = de_share_2,
    de_share_partner_children = de_share_3,
    de_share_other_persons = de_share_4,
    de_share_alone = de_share_5
  )

# 3. Add the country key to GREIX data and MERGE
merged_data <- greix_data %>%
  mutate(country_iso2 = "DE") %>%
  left_join(de_context_wide, by = "country_iso2")

# Create a continuous time variable for the x-axis
plot_data <- merged_data %>%
  mutate(Time = Year + (Quarter - 1) / 4)

# Find the latest year in the data and calculate average rent per city
latest_year <- max(plot_data$Year, na.rm = TRUE)

bar_data <- plot_data %>%
  filter(Year == latest_year) %>%
  group_by(City) %>%
  summarize(Avg_Rent_Index = mean(Rent_Index, na.rm = TRUE)) %>%
  arrange(Avg_Rent_Index) # Sort for the bar chart

# --- 3.1. Question 1: Current Affordability Snapshot ---
  # Create the horizontal bar chart
p2 <- ggplot(bar_data, aes(x = reorder(City, Avg_Rent_Index), y = Avg_Rent_Index, fill = Avg_Rent_Index)) +
  geom_col() +
  coord_flip() + # Makes it horizontal
  scale_fill_viridis_c(option = "magma", direction = -1) + 
  theme_minimal() +
  labs(
    title = paste("Student Housing Affordability Gap:", latest_year),
    subtitle = "Average Rent Index by City (Higher = Less Affordable)",
    x = "City",
    y = "Average Rent Index",
    fill = "Index"
  ) +
  theme(
    legend.position = "none", # Hide legend to save space
    axis.text.y = element_text(size = 10)
  )

print(p2)

# --- 3.2. Question 2: Fastest Rental Growth ---
# Calculate the change in Rent Index from the earliest to the latest year
growth_data <- plot_data %>%
  group_by(City) %>%
  summarize(
    start_rent = mean(Rent_Index[Year == min(Year, na.rm = TRUE)], na.rm = TRUE),
    end_rent = mean(Rent_Index[Year == max(Year, na.rm = TRUE)], na.rm = TRUE)
  ) %>%
  mutate(rent_change = end_rent - start_rent) %>%
  arrange(rent_change)

  # Create the horizontal bar chart for rent growth
p3 <- ggplot(growth_data, aes(x = reorder(City, rent_change), y = rent_change, fill = rent_change)) +
  geom_col() +
  coord_flip() +
  scale_fill_viridis_c(option = "plasma", direction = -1) + 
  theme_minimal() +
  labs(
    title = "Increase in Rental Prices Over Time",
    subtitle = "Absolute change in Rent Index (Earliest Year to Latest Year)",
    x = "City",
    y = "Change in Rent Index",
    fill = "Increase"
  ) +
  theme(
    legend.position = "none",
    axis.text.y = element_text(size = 10)
  )

print(p3)


# --- 3.3. Question 3: Nominal vs Inflation-Adjusted Rents ---
inflation_trend <- plot_data %>%
  group_by(Time, Inflation_adjusted) %>%
  summarize(Avg_Rent_Index = mean(Rent_Index, na.rm = TRUE), .groups = "drop") %>%
  mutate(
    Type = ifelse(Inflation_adjusted == 1, "Inflation Adjusted (Real)", "Nominal")
  )

p4 <- ggplot(inflation_trend, aes(x = Time, y = Avg_Rent_Index, color = Type, linetype = Type)) +
  geom_line(linewidth = 1.2) +
  scale_color_manual(values = c("Nominal" = "firebrick", "Inflation Adjusted (Real)" = "steelblue")) +
  theme_minimal() +
  labs(
    title = "Impact of Inflation on Student Housing Affordability",
    subtitle = "Average Rent Index across German university cities",
    x = "Year",
    y = "Average Rent Index",
    color = "Metric",
    linetype = "Metric"
  )

print(p4)

# --- 3.4. Question 4: Student Exposure to the Private Market ---
# Prepare the E8 data we extracted earlier into a clean format
e8_plot_data <- de_context_wide %>%
  select(-country_iso2) %>%
  pivot_longer(cols = everything(), names_to = "Housing_Type", values_to = "Percentage") %>%
  mutate(
    Housing_Type = case_when(
      Housing_Type == "de_share_parents" ~ "With Parents",
      Housing_Type == "de_share_student_accom" ~ "Student Accommodation",
      Housing_Type == "de_share_partner_children" ~ "With Partner/Children",
      Housing_Type == "de_share_other_persons" ~ "With Others (Friends, etc.)",
      Housing_Type == "de_share_alone" ~ "Living Alone"
    )
  )

# Create a stacked horizontal bar chart
p5 <- ggplot(e8_plot_data, aes(x = "Germany", y = Percentage, fill = Housing_Type)) +
  geom_col(width = 0.4) +
  coord_flip() +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal() +
  labs(
    title = "Student Housing Exposure in Germany",
    subtitle = "Where do students actually live? (National E8 Data)",
    x = "",
    y = "Percentage of Students (%)",
    fill = "Housing Type"
  ) +
  theme(legend.position = "bottom")

print(p5)

# --- 3.5. Question 5: Which Demographics are Most Vulnerable? ---
# Extract age group data from E8
e8_age_data <- e8_agg %>%
  filter(FG == "e_age", I == "accom_aggregated") %>%
  select(Age_Group = FGI, Indicator = II, DE) %>%
  mutate(DE = as.numeric(DE)) %>%
  filter(Indicator %in% c("1", "2", "5")) %>% # 1=Parents, 2=Partner, 5=Alone
  mutate(
    Housing = case_when(
      Indicator == "1" ~ "With Parents",
      Indicator == "2" ~ "With Partner/Spouse",
      Indicator == "5" ~ "Living Alone"
    )
  )

# Create a grouped bar chart
p6 <- ggplot(e8_age_data, aes(x = Age_Group, y = DE, fill = Housing)) +
  geom_col(position = "dodge") +
  scale_fill_brewer(palette = "Set1") +
  theme_minimal() +
  labs(
    title = "Housing Vulnerability by Age Group",
    subtitle = "Older students rely heavily on the private rental market",
    x = "Age Group",
    y = "Percentage (%)",
    fill = "Living Arrangement"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(p6)

# Save all plots
ggsave("figures/q1_current_affordability.png", plot = p2, width = 8, height = 6, dpi = 300)
ggsave("figures/q2_rent_growth.png", plot = p3, width = 8, height = 6, dpi = 300)
ggsave("figures/q3_inflation_impact.png", plot = p4, width = 8, height = 6, dpi = 300)
ggsave("figures/q4_student_exposure.png", plot = p5, width = 8, height = 4, dpi = 300)
ggsave("figures/q5_age_vulnerability.png", plot = p6, width = 8, height = 6, dpi = 300)