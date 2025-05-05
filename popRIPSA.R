library(tidyverse)
library(readxl)

pop <- read_csv2(file = "brute/ibge_cnv_popsvs2024br_treated.csv")

pop_long <- pop |> 
  pivot_longer(cols = `2000`:`2024`, values_to = "POP", names_to = "Ano") |> 
  transmute(
    MUNCOD = ifelse(substr(MUN, 1, 1) == "'", 
                    substr(MUN, 3, 8),
                    substr(MUN, 1, 6)),
    MUN = ifelse(substr(MUN, 1, 1) == "'", 
                     substr(MUN, 10, nchar(MUN)-2),
                     substr(MUN, 8, nchar(MUN))),
    Ano,
    POP
  )

pop_long |> write_csv(file = "popBR2000-2024.long.csv")
