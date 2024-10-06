library(readxl)
library(dplyr)

lead <- read_excel("Lead.xlsx")
lead <- lead %>% filter(!is.na(Data))
saveRDS(lead, file = "data/lead_rds.rds")
write.csv(lead, file = "data/lead.csv", row.names = FALSE)


lead <- read_excel("Orçamentos.xlsx")
saveRDS(lead, file = "data/orcamentos_rds.rds")
write.csv(lead, file = "data/orcamentos.csv", row.names = FALSE)
