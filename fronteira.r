library(tidyverse)

# FONTES: 
## Municípios da Faixa de Fronteira e Cidades Gêmeas
## https://www.ibge.gov.br/geociencias/organizacao-do-territorio/estrutura-territorial/24073-municipios-da-faixa-de-fronteira.html

fronteira <- readxl::read_xlsx("brute/Mun_Faixa_de_Fronteira_Cidades_Gemeas_2021.xlsx")

fronteira %>% 
  mutate(
    cidade_gemea = if_else(is.na(CID_GEMEA), 0, 1),
    fronteira = if_else(SEDE_FAIXA=="sim", 1, 0)
  ) %>% 
  filter(fronteira == 1) %>% 
  select(NM_REGIAO, CD_MUN, NM_UF, cidade_gemea, fronteira) -> front.mun

front.mun %>% 
  group_by(NM_REGIAO) %>% 
  summarise(
    cid_gemea = sum(cidade_gemea),
    cid_nao_gemea = sum(cidade_gemea == 0)
  )

# Salvando
front.mun %>% write_csv("fronteira.csv")
