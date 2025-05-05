# popBR_mun

## Estimativas populacionais por município 2000-2024

Estimativas populacionais por município para os anos 2000 até 2024 realizadas 
pelo CGI Demográfico/[RIPSA](https://www.ripsa.org.br/) e CGIAE/SVSA/Ministério da Saúde.

O arquivo `popBR2000-2024.long.csv` contém as populações por ano e município no formato longo.




Os dados brutos das estimativas por municipio, ano e idade estão no ftp do datasus 
[ftp://ftp.datasus.gov.br/dissemin/publicos/IBGE/POPSVS/], mas podem obtidos diretamente 
via [TABNET](http://tabnet.datasus.gov.br/cgi/tabcgi.exe?ibge/cnv/popsvs2024br.def).

-   `MUNCOD` - Código do município
-   `MUN` - Código do IBGE de 6 dígitos para os municípios.
-   `Ano` - Ano da estimativa, 2000:2024. 
-   `POP` - População estimada, para os anos de 2000, 2010 e 2022 são estimativas censitárias.


```
pop <- read.csv("popBR2000-2024.long.csv")
```
E se quiser ler direto do git sem precisar baixar:

```
pop.git <- read.csv("https://raw.githubusercontent.com/lsbastos/popBR_mun/refs/heads/master/popBR2000-2024.long.csv")
```


## Estimativas do IBGE para o TCU (OLD)

População estimada pelo IBGE para os 5570 municípios a partir do censos de 2010 e 2022, e por projeções para o Tribunal de Contas da União (TCU) para os anos de 2011 até 2021.

O arquivo `pop2010-2022_2024.csv` tem 5570 linhas e 18 colunas, e foi construído usando o script `pop.r`. As variáveis são:

-   `COD. UF` - Código da UF
-   `UF` - Sigla da UF
-   `CODMUN7` - Código do IBGE para os municípios com 7 dígitos.
-   `NOME DO MUNICÍPIO` - adivinha?
-   `POP22` - População calculada no censo de 2022
-   `POP10` - População calculada no censo de 2010
-   `POP24` e `POP21`:`POP11` - População estimada pelo IBGE para o TCU para s anos de 2024, 2021:2011.

Os dados brutos baixados no site do IBGE estao na pasta `brute/`.

E o arquivo `pop2010-2022_2024.long.csv` contém 6 colunas:

-   `COD. UF` - Código da UF
-   `UF` - Sigla da UF
-   `CODMUN7` - Código do IBGE para os municípios com 7 dígitos.
-   `NOME DO MUNICÍPIO` - Nome do município
-   `Ano`- Ano 2010:2024
-   `Pop` - População por municipio/Ano. (Censo para os anos 2010 e 2022, e projetada para TCU para os anos 2011 até 2021).
