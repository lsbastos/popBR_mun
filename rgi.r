library(tidyverse)

# https://www.ibge.gov.br/geociencias/organizacao-do-territorio/divisao-regional/15778-divisoes-regionais-do-brasil.html
# rgi Regiões Geográficas Imediatas - 2017
# rgint Regiões Geográficas Intermediárias - 2017

tbl <- readxl::read_xlsx("rgi/regioes_geograficas_composicao_por_municipios_2017_20180911.xlsx")

# Adicionar as rgi e rgint ao arquivo poptcu2010-2022.csv

pop <- read_csv("~/Git/popBR_mun/poptcu2010-2022.csv")

poprgi <- pop %>% 
  left_join(tbl %>% 
              transmute(
                CODMUN7 = as.numeric(CD_GEOCODI),
                CODRGI = as.numeric(cod_rgi),
                `NOME RGI` = nome_rgi,
                CODRGINT = as.numeric(cod_rgint),
                `NOME RGINT` = nome_rgint,
              ), by = "CODMUN7")

#write_csv(poprgi, file = "~/Git/popBR_mun/poptcu2010-2022_rgi.csv")
