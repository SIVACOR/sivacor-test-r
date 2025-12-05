# Load renv and initialize if needed
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}
library(renv)

if (!file.exists("renv.lock")) {
  renv::init()
} else {
  renv::restore()
}

# Install required packages via renv
required_packages <- c("palmerpenguins", "dplyr","ggplot2","knitr")
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    renv::install(pkg)
  }
}

renv::snapshot()

library(palmerpenguins)
library(dplyr)

# Load the penguins dataset
data("penguins", package = "palmerpenguins")

# Remove rows with missing values
penguins_clean <- na.omit(penguins)

# Descriptive statistics
summary_stats <- penguins_clean %>%
  summarise(
    mean_bill_length = mean(bill_length_mm),
    sd_bill_length = sd(bill_length_mm),
    mean_bill_depth = mean(bill_depth_mm),
    sd_bill_depth = sd(bill_depth_mm),
    mean_flipper_length = mean(flipper_length_mm),
    sd_flipper_length = sd(flipper_length_mm),
    mean_body_mass = mean(body_mass_g),
    sd_body_mass = sd(body_mass_g)
  )

print("Descriptive statistics for penguins dataset:")
print(summary_stats)

# Grouped statistics by species
grouped_stats <- penguins_clean %>%
  group_by(species) %>%
  summarise(
    mean_bill_length = mean(bill_length_mm),
    mean_body_mass = mean(body_mass_g),
    count = n()
  )

print("Grouped statistics by species:")
print(grouped_stats)

# Output summary_stats as LaTeX table
summary_stats_latex <- knitr::kable(summary_stats, format = "latex", caption = "Descriptive statistics for penguins dataset")
cat(summary_stats_latex, file = "penguins_summary_table.tex")

# Output grouped_stats as LaTeX table
grouped_stats_latex <- knitr::kable(grouped_stats, format = "latex", caption = "Grouped statistics by species")
cat(grouped_stats_latex, file = "penguins_grouped_table.tex")

# Create and save a histogram of bill length
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  renv::install("ggplot2")
}
library(ggplot2)
hist_plot <- ggplot(penguins_clean, aes(x = bill_length_mm)) +
  geom_histogram(binwidth = 2, fill = "skyblue", color = "black") +
  labs(title = "Histogram of Bill Length (mm)", x = "Bill Length (mm)", y = "Count")
ggsave("penguins_bill_length_histogram.pdf", plot = hist_plot)

# ============================================================
system("chmod +x linux-system-info.sh")
system("./linux-system-info.sh")

