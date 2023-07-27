library(tidyverse)
library(readxl)
# library(geobr)

# FONTES: 
# Populaçào 2022 (CENSO)
# https://sidra.ibge.gov.br/tabela/4709

pop2022.censo <- read_xlsx(path = "brute/POP2022 CD2022_Populacao_Coletada_Imputada_e_Total_Municipio_e_UF.xlsx", 
                    sheet = "Municípios",
                    range = "B3:H5573"
)

pop2022.censo <- pop2022.censo %>% 
  mutate(
    CODMUN7 = paste0(`COD. UF`, `COD. MUNIC`),
    POP22.censo = `POP. TOTAL`,
  ) %>% select(`COD. UF`, UF, CODMUN7, `NOME DO MUNICÍPIO`, POP22.censo)
# ) %

pop <- pop %>% 
  left_join(pop2022.censo %>% 
              mutate(
                CODMUN7 = as.numeric(CODMUN7)
              ) %>% 
              select(CODMUN7,POP22.censo), by = "CODMUN7")


pop <- read_csv("~/Git/popBR_mun/poptcu2010-2022.csv")

pop %>% ggplot(aes(x = POP10)) + 
  geom_point(aes(y = POP22, color = "Projecao 2022 (TCU)")) + 
  geom_point(aes(y = POP22.censo, color = "Censo 2022")) + 
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  theme_classic()


pop %>% 
  mutate(
    erroProjTCU22 = (POP22 -POP22.censo)/POP22.censo,
    erroCenso12 = (POP12 - POP22.censo)/POP22.censo,
    erroCenso10 = (POP10 - POP22.censo)/POP22.censo,
    Regiao = substr(as.character(CODMUN7),1,1),
    Regiao = case_when(
      Regiao ==  "1" ~ "Norte",
      Regiao ==  "2" ~ "Nordeste",
      Regiao ==  "3" ~ "Sudeste",
      Regiao ==  "4" ~ "Centro Oeste",
      Regiao ==  "5" ~ "Sul")
  ) %>% #View()
  group_by(Regiao) %>% 
  summarise(
    ProjTCU22 =sqrt(mean(erroProjTCU22^2)),
    Censo10 = sqrt(mean(erroCenso10^2, na.rm = T)),
    TCU12 = sqrt(mean(erroCenso12^2)),
  )



library(geobr)

BR.0 <- read_municipality(
  code_muni = "all",
  year = 2010,
  simplified = TRUE,
  showProgress = TRUE
)


pop <- pop %>% 
  mutate(
    ErroRelativo =(POP22 - POP22.censo)/POP22.censo,
    ErroRelativo.cat = cut( 
      ErroRelativo, 
      breaks = c(-1,seq(-0.2,0.2, by=0.05),1),
      labels = c("< -20", "-20 a -15", "-15 a -10", "-10 a -5", "-5 a 0",
                 "0 a 5", "5 a 10", "10 a 15", "15 a 20", "> 20")
    )
  )
pop %>% group_by(ErroRelativo.cat) %>% tally()
  

pop %>% #group_by(ErroRelativo.cat) %>% 
  ggplot() + 
  geom_bar(aes(x = ErroRelativo.cat), fill = "darkblue") +
  theme_bw()



BR <- BR.0 %>% 
 left_join(pop, by = c("code_muni"="CODMUN7"))


no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank())




BR %>% 
  drop_na(ErroRelativo.cat) %>% 
  ggplot() + 
  geom_sf(
    aes(fill=ErroRelativo.cat), 
    # color="#FEBF57", 
    size=.15, 
    # show.legend = FALSE
  ) +
  labs(subtitle="Erro relativo (%) da projeção do TCU e censo para 2022", size=8) +
  # scale_fill_distiller(palette = "Blues", name="Proporção de descartados", limits = c(0,1)) +
  scale_fill_brewer(palette = "RdBu", 
                    name="Erro relativo (%)", 
                    # na.value = "grey50", 
                    ) +
  theme_minimal() +
  no_axis

