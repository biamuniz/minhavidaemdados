#Carregando os pacotes
library(tidyverse) #para lidar com os dados (ggplot tá aí!)
library(lubridate) #para lidar com as datas
library(weathermetrics) #para converter a temperatura
library(janitor) #clean_names
library(ggthemes) #outros temas
library(bbplot) #outros temas

# cria o objeto data e coloca os dados do CSV
data <- read.csv2("data-raw/3180668.csv",sep=',') |>
  clean_names()

# uma olhadinha nos dados
data  |>
  glimpse()

# converte os dados de fahrenheit para celsius
data$tmin <- fahrenheit.to.celsius(data$tmin)
data$tmax <- fahrenheit.to.celsius(data$tmax)

#selecionando as colunas de interesse e filtrando o período que eu vou analisar
data_clean <- data |> 
  select(
    date,
    tmax,
    tmin
  ) |>  
  filter(
    date > "2022-09-06")


data_clean |> 
  write_rds("data-processed/01-weather.rds")

figura <- data_clean %>%
  ggplot() +
  aes(x = factor(date)) +
  geom_segment(aes(x=date, xend=date, y=tmin, yend=tmax)) +
  geom_point( aes(x=date, y=tmin), color="lightblue", size=3 ) +
  geom_point( aes(x=date, y=tmax), color="orange", size=3) +
  bbc_style()+
  labs(title = "Põe o casaco, tira o casaco", subtitle="Registros de temperaturas mínima e máxima em cada dia que estive em \nAustin, capital do Texas", x = "Dia", y = "Temperatura (°C)")+
  theme(axis.text.x = element_text(angle = 90)) 

figura +
  theme(axis.title.y = element_text(size = 15), axis.title.x = element_text(size = 15), axis.text.x = element_text(size = 5),plot.title = element_text(size = 20, face = "bold"), plot.subtitle = element_text(size = 15))
#Salvando
ggsave("images/figura.png", plot = figura)