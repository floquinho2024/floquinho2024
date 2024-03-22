library(readxl)

lead <- read_excel("Lead.xlsx")
saveRDS(lead, file = "data/lead_rds.rds")
write.csv(lead, file = "data/lead.csv", row.names = FALSE)
