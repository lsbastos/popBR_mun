library(tidyverse)
library(readxl)
# library(geobr)

# FONTES: 
## Estimativas do TCU para 2011 a 2021, e 2024
## https://www.ibge.gov.br/estatisticas/sociais/populacao/9103-estimativas-de-populacao.html?edicao=17283&t=downloads

## Estimativas do TCU para 2022
## https://www.ibge.gov.br/estatisticas/sociais/populacao/22827-censo-demografico-2022.html?edicao=35938&t=resultados

# Populaçào 2010 (CENSO)
# https://sidra.ibge.gov.br/tabela/1378

 # CENSO 2022

pop2022 <- read_xls(path = "brute/POP2022_Municipios.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572"
)

pop <- pop2022 %>% 
  mutate(
    CODMUN7 = paste0(`COD. UF`, `COD. MUNIC`),
    # Encontra algum parentesis no campo populacao, se sim contar até ele
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
  ) %>% select(`COD. UF`, UF, CODMUN7, `NOME DO MUNICÍPIO`, POP22)
  # ) %>% select(CODMUN7, POP22)

# CENSO 2010
pop2010 <- read_xlsx("brute/tabela1378.xlsx", range = "A7:E5576", 
                     col_names = c("CODMUN7", "Mun", "a", "b", "POP10")) %>% 
  transmute(
    CODMUN7 = (CODMUN7),
    POP10 = as.numeric(POP10)
  )

pop <- pop %>% left_join(y = pop2010, by = "CODMUN7")



################
pop.fun <- function(x, comma = T){
  xx <- x  %>% 
    mutate(
      CODMUN7 = paste0(`COD. UF`, `COD. MUNIC`),
      End = unlist(gregexpr("\\(", `POPULAÇÃO ESTIMADA`)),
      pop = ifelse(End == -1, 
                   as.numeric(`POPULAÇÃO ESTIMADA`),
                   as.numeric(substr(`POPULAÇÃO ESTIMADA`, 
                                     start=1,
                                     stop=End-1))*ifelse(comma==T,1000,1)),
      # POP20 = as.numeric(POP20),
      # POP20 = ifelse(is.na(POP20), 
      #                   as.numeric(
      #                     substr(
      #                       `POPULAÇÃO ESTIMADA`, 
      #                       start = 1,
      #                       end = unlist(gregexpr("\\(", `POPULAÇÃO ESTIMADA`)))-1), 
      #                   POP2020)
    ) 
  
  xx %>% select(CODMUN7, pop)
}



pop2024 <- read_xls(path = "brute/estimativa_dou_2024.xls", 
                    sheet = "MUNICÍPIOS",
                    range = "A2:E5572"
)

temp <- pop.fun(pop2024) %>% rename(POP24 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")


pop2021 <- read_xls(path = "brute/estimativa_dou_2021.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572"
)

temp <- pop.fun(pop2021) %>% rename(POP21 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")


pop2020 <- read_xls(path = "brute/estimativa_dou_2020.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572", 
)

temp <- pop.fun(pop2020, comma = F) %>% rename(POP20 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")

pop2019 <- read_xls(path = "brute/estimativa_dou_2019.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572", 
)

temp <- pop.fun(pop2019, comma = F) %>% rename(POP19 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")


pop2018 <- read_xls(path = "brute/estimativa_dou_2018.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572", 
)

temp <- pop.fun(pop2018, comma = T) %>% rename(POP18 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")

pop2017 <- read_xls(path = "brute/estimativa_dou_2017.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572", 
)

temp <- pop.fun(pop2017, comma = F) %>% rename(POP17 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")

pop2016 <- read_xls(path = "brute/estimativa_dou_2016.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572", 
)

temp <- pop.fun(pop2016, comma = T) %>% rename(POP16 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")


pop2015 <- read_xls(path = "brute/estimativa_dou_2015.xls", 
                    sheet = "Municípios",
                    range = "A3:E5573", 
)

temp <- pop.fun(pop2015, comma = T) %>% rename(POP15 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")


pop2014 <- read_xls(path = "brute/estimativa_dou_2014.xls", 
                    sheet = "Municípios",
                    range = "A3:E5573", 
)

temp <- pop.fun(pop2014) %>% rename(POP14 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")

pop2013 <- read_xls(path = "brute/estimativa_dou_2013.xls", 
                    sheet = "Municípios",
                    range = "A3:E5573", 
)

temp <- pop.fun(pop2013) %>% rename(POP13 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")


pop2012 <- read_xls(path = "brute/estimativa_dou_2012.xls", 
                    sheet = "Municípios",
                    range = "A2:E5572", 
)

temp <- pop.fun(pop2012) %>% rename(POP12 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")


pop2011 <- read_xls(path = "brute/estimativa_dou_2011.xls", 
                    sheet = "MUNICÍPIOS",
                    range = "A3:E5573", 
)

temp <- pop.fun(pop2011, comma = T) %>% rename(POP11 = pop)
pop <- pop %>% left_join(y = temp, by = "CODMUN7")


# write_csv(pop, file = "poptcu2010-2022_2024.csv")

pop.long <- pop %>% 
  pivot_longer( 
    cols = POP22:POP11,
    names_to = "Ano",
    values_to = "Pop"
  ) %>% 
  mutate(
    Ano = as.numeric(substr(Ano, 4,5)) + 2000
  ) %>% 
  arrange(desc(Ano), CODMUN7) 

# pop.long %>% write_csv(file = "poptcu2010-2022_2024.long.csv")
  
