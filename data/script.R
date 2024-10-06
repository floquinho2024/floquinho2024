library(readxl)
library(dplyr)
library(lubridate)

lead <- read_excel("Lead.xlsx")
lead <- lead %>% filter(!is.na(Data))
saveRDS(lead, file = "data/lead_rds.rds")
write.csv(lead, file = "data/lead.csv", row.names = FALSE)

# Criar o resumo para Twilio
ano_corrente <- max(year(lead$Data))
ultima_atualizacao <- format(max(lead$Data), '%d/%m/%Y')

total_leads_ano <- lead %>%
  filter(year(Data) == ano_corrente) %>%
  summarise(total_leads_ano = n()) %>%
  pull(total_leads_ano)

total_leads_mes <- lead %>%
  filter(month(Data) == max(month(Data))) %>%
  summarise(total_leads_mes = n()) %>%
  pull(total_leads_mes)
resumo <- paste("Leads",
                sprintf("Total no ano: %d", total_leads_ano),
                sprintf("Total no mês: %d", total_leads_mes),
                sprintf("Última atualização: %s", ultima_atualizacao),
                sep = "\n")

writeLines(resumo, "data/resumo_leads.txt")


## Orçamentos
lead <- read_excel("Orçamentos.xlsx")
saveRDS(lead, file = "data/orcamentos_rds.rds")
write.csv(lead, file = "data/orcamentos.csv", row.names = FALSE)
