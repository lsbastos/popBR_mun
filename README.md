# popBR_mun

População estimada pelo IBGE para os 5570 municípios a partir do censos de 2010 e 2022, e por projeções para o Tribunal de Contas da União (TCU) para os anos de 2011 até 2021.

O arquivo `pop2010-2022_2024.csv` tem 5570 linhas e 18 colunas, e foi construído usando o script `pop.r`. As variáveis são:

  - `COD. UF` - Código da UF
  - `UF` - Sigla da UF
  - `CODMUN7` - Código do IBGE para os municípios com 7 dígitos. 
  - `NOME DO MUNICÍPIO` - adivinha?
  - `POP22` - População calculada no censo de 2022
  - `POP10` - População calculada no censo de 2010
  - `POP24` e `POP21`:`POP11` - População estimada pelo IBGE para o TCU para s anos de 2024, 2021:2011.

Os dados brutos baixados no site do IBGE estao na pasta `brute/`. 

E o arquivo `pop2010-2022_2024.long.csv` contém 6 colunas:

  - `COD. UF` - Código da UF
  - `UF` - Sigla da UF
  - `CODMUN7` - Código do IBGE para os municípios com 7 dígitos. 
  - `NOME DO MUNICÍPIO` - Nome do município
  - `Ano`- Ano 2010:2024
  - `Pop` - População por municipio/Ano. (Censo para os anos 2010 e 2022, e projetada para TCU para os anos 2011 até 2021).
