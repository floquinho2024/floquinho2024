library(readxl)
library(dplyr)
library(stringr)
library(lubridate)

lead <- read_excel("Lead.xlsx")
lead <- lead %>% filter(!is.na(Data))
saveRDS(lead, file = "data/lead_rds.rds")
write.csv(lead, file = "data/lead.csv", row.names = FALSE)

# Criar o resumo para Twilio
formatar_moeda <- function(valor) {
  paste('R$', format(valor, big.mark = ".", decimal.mark = ',', scientific = FALSE, nsmall = 2))
}

ultima_atualizacao <- format(max(lead$Data), '%d/%m/%Y')
mes_atual <- str_to_lower(month(max(lead$Data), label = TRUE, abbr = TRUE, locale = "pt_BR.UTF-8"))
ano_atual <- year(max(lead$Data))

total_leads_ano <- lead %>%
  filter(year(Data) == ano_atual) %>%
  summarise(total_leads_ano = n()) %>%
  pull(total_leads_ano)

total_leads_mes <- lead %>%
  filter(month(Data) == max(month(Data))) %>%
  summarise(total_leads_mes = n()) %>%
  pull(total_leads_mes)

fechou_orcamento_mes <- lead %>%
  filter(month(Data) == max(month(Data))) %>%
  filter(Status == "Fechou orçamento") %>%
  summarise(fechou_orcamento_mes = n()) %>%
  pull(fechou_orcamento_mes)

agendamentos_mes <- lead %>%
  filter(month(Data) == max(month(Data))) %>%
  filter(AGENDAMENTO == "SIM") %>%
  summarise(agendamentos_mes = n()) %>%
  pull(agendamentos_mes)

comparecimentos_mes <- lead %>%
  filter(month(Data) == max(month(Data))) %>%
  filter(COMPARECIMENTO == "SIM") %>%
  summarise(comparecimentos_mes = n()) %>%
  pull(comparecimentos_mes)

vendas_mes <- lead %>%
  filter(month(Data) == max(month(Data))) %>%
  filter(VENDA == "SIM") %>%
  summarise(vendas_mes = n()) %>%
  pull(vendas_mes)

faturamento_mes <- lead %>%
  filter(month(Data) == max(month(Data))) %>%
  summarise(faturamento_mes = sum(FATURAMENTO, na.rm = TRUE)) %>%
  pull(faturamento_mes)

resumo <- paste("*Relatório de Leads*",
                sprintf("Leads no ano: %d", total_leads_ano),
                "",
                sprintf("Resultados no mês (%s/%d):", mes_atual, ano_atual),  # Mês e ano
                sprintf("Leads: %d", total_leads_mes),
                sprintf("Orçamentos fechados: %d", fechou_orcamento_mes),
                sprintf("Agendamentos: %d", agendamentos_mes),
                sprintf("Comparecimentos: %d", comparecimentos_mes),
                sprintf("Vendas: %d", vendas_mes),
                sprintf("Faturamento: %s", formatar_moeda(faturamento_mes)),
                "",
                sprintf("Última atualização: %s", ultima_atualizacao),
                sep = "\n")

writeLines(resumo, "resumo_leads.txt")


## Orçamentos
lead <- read_excel("Orçamentos.xlsx")
saveRDS(lead, file = "data/orcamentos_rds.rds")
write.csv(lead, file = "data/orcamentos.csv", row.names = FALSE)
