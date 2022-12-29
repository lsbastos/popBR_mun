library(tidyverse)
library(readxl)
library(geobr)

# FONTES: 
## Estimativas do TCU para 2020 e 2021
## https://www.ibge.gov.br/estatisticas/sociais/populacao/9103-estimativas-de-populacao.html?edicao=17283&t=downloads

## Estimativas do TCU para 2022
## https://www.ibge.gov.br/estatisticas/sociais/populacao/22827-censo-demografico-2022.html?edicao=35938&t=resultados

pop2020 <- read_xls(path = "estimativa_dou_2020.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572", 
)

pop <- pop2020 %>% 
  mutate(
    CODMUN7 = paste0(`COD. UF`, `COD. MUNIC`),
    End = unlist(gregexpr("\\(", `POPULAÇÃO ESTIMADA`)),
    POP20 = ifelse(End == -1, 
                  `POPULAÇÃO ESTIMADA`,
                  substr(`POPULAÇÃO ESTIMADA`, 
                         start=1,
                         stop=End-1)),
    POP20 = as.numeric(POP20),
    # POP20 = ifelse(is.na(POP20), 
    #                   as.numeric(
    #                     substr(
    #                       `POPULAÇÃO ESTIMADA`, 
    #                       start = 1,
    #                       end = unlist(gregexpr("\\(", `POPULAÇÃO ESTIMADA`)))-1), 
    #                   POP2020)
  ) %>% select(`COD. UF`, UF, CODMUN7, `NOME DO MUNICÍPIO`, POP20)


pop2021 <- read_xls(path = "estimativa_dou_2021.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572"
)

temp <- pop2021 %>% 
  mutate(
    CODMUN7 = paste0(`COD. UF`, `COD. MUNIC`),
    End = unlist(gregexpr("\\(", `POPULAÇÃO ESTIMADA`)),
    POP21 = ifelse(End == -1, 
                   as.numeric(`POPULAÇÃO ESTIMADA`),
                   as.numeric(substr(`POPULAÇÃO ESTIMADA`, 
                          start=1,
                          stop=End-1))*1000),
    # POP20 = as.numeric(POP20),
    # POP20 = ifelse(is.na(POP20), 
    #                   as.numeric(
    #                     substr(
    #                       `POPULAÇÃO ESTIMADA`, 
    #                       start = 1,
    #                       end = unlist(gregexpr("\\(", `POPULAÇÃO ESTIMADA`)))-1), 
    #                   POP2020)
  ) %>% select(CODMUN7, POP21)

pop <- pop %>% left_join(y = temp, by = "CODMUN7")

pop2022 <- read_xls(path = "POP2022_Municipios.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572"
)

temp <- pop2022 %>% 
  mutate(
    CODMUN7 = paste0(`COD. UF`, `COD. MUNIC`),
    End = unlist(gregexpr("\\(", `POPULAÇÃO`)),
    POP22 = ifelse(End == -1, 
                   as.numeric(`POPULAÇÃO`),
                   as.numeric(substr(`POPULAÇÃO`, 
                                     start=1,
                                     stop=End-1))*1000),
    # POP20 = as.numeric(POP20),
    # POP20 = ifelse(is.na(POP20), 
    #                   as.numeric(
    #                     substr(
    #                       `POPULAÇÃO ESTIMADA`, 
    #                       start = 1,
    #                       end = unlist(gregexpr("\\(", `POPULAÇÃO ESTIMADA`)))-1), 
    #                   POP2020)
  ) %>% select(CODMUN7, POP22)

pop <- pop %>% left_join(y = temp, by = "CODMUN7")


# write_csv(pop, file = "poptcu2020-2022.csv")

aaa <- pop %>% 
  mutate(
    CODMUN7 = as.numeric(CODMUN7),
    RR2120 = (POP21 / POP20 - 1) * 100,
    RR2221 = (POP22 / POP21 - 1) * 100
  )


BR <- read_municipality(
  code_muni = "all",
  year = 2010,
  simplified = TRUE,
  showProgress = TRUE
)

BR <- BR %>% 
  left_join(aaa, by = c("code_muni"="CODMUN7")) 


ggplot() +
  geom_sf(data=BR, aes(fill=RR2120), color= NA, size=.15) +
  labs(subtitle="Variação percentual do crescimento populacional de 2020 para 2021", size=8) +
  scale_fill_distiller(palette = "RdBu", name="Variação populacional") +
  theme_minimal() 


ggplot() +
  geom_sf(data=BR, aes(fill=RR2221), color= NA, size=.15) +
  labs(subtitle="Variação percentual do crescimento populacional de 2021 para 2022", size=8) +
  scale_fill_distiller(palette = "RdBu", name="Variação populacional") +
  theme_minimal() 

#  Adaptando o código do Lucas Warwar disponibilizado aqui:
# https://gist.github.com/lucaswarwar/fcfec073e6331d102f032b2612dc0190

pop <- pop %>% dplyr::mutate(
  crescimento = POP22/POP21 - 1,
  label = data.table::fcase(
    crescimento < -.30, 'Redução de 30% ou mais',
    crescimento >= -.30 & crescimento < -.15, 'Redução de 15% a 30%',
    crescimento >= -.15 & crescimento < -.05, 'Redução de 5% a 15%',
    crescimento >= -.05 & crescimento < 0, 'Redução de até 5%',
    crescimento >= 0 & crescimento <= 0.05, 'Crescimento de até 5%',
    crescimento > 0.05 & crescimento <= 0.15, 'Crescimento de 5% a 15%',
    crescimento > 0.15 & crescimento <= 0.3, 'Crescimento de 15% a 30%',
    crescimento > 0.3, 'Crescimento de 30% ou mais'))

pop$label = factor(
  pop$label, levels = c(
    "Redução de 30% ou mais", 
    "Redução de 15% a 30%", 
    "Redução de 5% a 15%" ,
    "Redução de até 5%" ,
    "Crescimento de até 5%",
    "Crescimento de 5% a 15%",
    "Crescimento de 15% a 30%",
    "Crescimento de 30% ou mais"), ordered = T)

muni = geobr::read_municipality()
uf = geobr::read_state()

pop$code_muni = as.integer(pop$CODMUN7)

muni = muni |>
  dplyr::left_join(pop) |>
  sf::st_as_sf()

muni = na.omit(muni)

ggplot() +
  geom_sf(data = uf, fill = NA) +
  geom_sf(data = muni, aes(fill=label),color=NA,alpha=.75) +
  # annotate('text', x = -37.5, y = 2.5, size = 4.5,
  #          label = 'Estados com\nmaior crescimento:\nRR (41%), MT (25%) e SC (24%)',
  #          color = '#4d9221') +
  # annotate('text', x = -37.5, y = -28.5, size = 4.5,
  #          label = 'Estados com\nmenor crescimento:\nAL (0.1%), PE (2.8%) e MA (3.4%)',
  #          color = '#c51b7d') +
  scale_fill_brewer(palette = 'PiYG') +
  labs(
    title = 'Evolução das estimativas populacionais de 2021 e 2022',
    # subtitle = 'Fonte: IBGE. Baseado nos resultados preliminares do Censo 2022 coletados até 25/12.',
    # caption = 'Elaborado por @LucasWarwar'
    ) +
  theme_minimal() + 
  theme(
    axis.title = element_blank(),
    plot.caption = element_text(vjust = 1),
    legend.title = element_blank(),
    legend.text = element_text(size = 10),
    legend.position = c(.18,.25),
    panel.grid = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_blank()
  )
