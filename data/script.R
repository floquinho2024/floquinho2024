library(readxl)
library(dplyr)
library(lubridate)

lead <- read_excel("Lead.xlsx")
lead <- lead %>% filter(!is.na(Data))
saveRDS(lead, file = "data/lead_rds.rds")
write.csv(lead, file = "data/lead.csv", row.names = FALSE)

# Criar o resumo para Twilio
formatar_moeda <- function(valor) {
  paste('R$', format(valor, big.mark = ".", decimal.mark = ',', scientific = FALSE, nsmall = 2))
}

nomes_meses <- c("jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez")

# Calcular informações
ultima_atualizacao <- format(max(lead$Data), '%d/%m/%Y')

mes_numero <- month(max(lead$Data))
mes_atual <- nomes_meses[mes_numero]
ano_atual <- year(max(lead$Data))

total_leads_ano <- lead %>%
  filter(year(Data) == ano_atual) %>%
  summarise(total_leads_ano = n()) %>%
  pull(total_leads_ano)

total_leads_mes <- lead %>%
  filter(month(Data) == mes_numero & year(Data) == ano_atual) %>%
  summarise(total_leads_mes = n()) %>%
  pull(total_leads_mes)

fechou_orcamento_mes <- lead %>%
  filter(month(Data) == mes_numero & year(Data) == ano_atual) %>%
  filter(Status == "Fechou orçamento") %>%
  summarise(fechou_orcamento_mes = n()) %>%
  pull(fechou_orcamento_mes)

agendamentos_mes <- lead %>%
  filter(month(Data) == mes_numero & year(Data) == ano_atual) %>%
  filter(AGENDAMENTO == "SIM") %>%
  summarise(agendamentos_mes = n()) %>%
  pull(agendamentos_mes)

comparecimentos_mes <- lead %>%
  filter(month(Data) == mes_numero & year(Data) == ano_atual) %>%
  filter(COMPARECIMENTO == "SIM") %>%
  summarise(comparecimentos_mes = n()) %>%
  pull(comparecimentos_mes)

vendas_mes <- lead %>%
  filter(month(Data) == mes_numero & year(Data) == ano_atual) %>%
  filter(VENDA == "SIM") %>%
  summarise(vendas_mes = n()) %>%
  pull(vendas_mes)

faturamento_mes <- lead %>%
  filter(month(Data) == mes_numero & year(Data) == ano_atual) %>%
  summarise(faturamento_mes = sum(FATURAMENTO, na.rm = TRUE)) %>%
  pull(faturamento_mes)

resumo <- paste("*Relatório de Leads*",
                sprintf("Leads no ano: %d", total_leads_ano),
                "",
                sprintf("Resultados no mês (%s/%d):", mes_atual, ano_atual),  # Mês e ano usando nomes_meses
                sprintf("Leads: %d", total_leads_mes),
                sprintf("Orçamentos fechados: %d", fechou_orcamento_mes),
                sprintf("Agendamentos: %d", agendamentos_mes),
                sprintf("Comparecimentos: %d", comparecimentos_mes),
                sprintf("Vendas: %d", vendas_mes),
                sprintf("Faturamento: %s", formatar_moeda(faturamento_mes)),
                "",
                sprintf("Última atualização: %s", ultima_atualizacao),
                sep = "\n")

writeLines(resumo, "data/resumo_leads.txt")


## Orçamentos
lead <- read_excel("Orçamentos.xlsx")
saveRDS(lead, file = "data/orcamentos_rds.rds")
write.csv(lead, file = "data/orcamentos.csv", row.names = FALSE)
