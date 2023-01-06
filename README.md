# popBR_mun

População estimada pelo IBGE para os 5570 municípios para Tribunal de Contas da União (TCU) para os anos de 2011 até 2022. E para 2010 a população calculada censo do mesmo ano.

O arquivo poptcu2010-2022.csv tem 5571 linhas e 17 colunas, e foi construído usando o script `pop.r`.


  - `COD. UF` - Código da UF
  - `UF` - Sigla da UF
  - `CODMUN7` - Código do IBGE para os municípios com 7 dígitos. 
  - `NOME DO MUNICÍPIO` - adivinha?
  - `POP22`:`POP11` - População estimada pelo IBGE para o TCU
  - `POP10` - População calculada no censo de 2010


Os dados brutos baixados no site do IBGE estao na pasta `brute/`.
