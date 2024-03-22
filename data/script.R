library(readxl)

lead <- read_excel("Lead.xlsx")
saveRDS(lead, file = "data/lead_rds.rds")
