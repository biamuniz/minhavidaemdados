library(tidyverse) #para lidar com os dados (ggplot tá aí!)
library(lubridate) #para lidar com as datas
library(weathermetrics) #para converter a temperatura
library(janitor) #clean_names
library(ggthemes) #outros temas


# cria o objeto data e coloca os dados do CSV
data <- read_csv("data-raw/USD_BRL Historical Data.csv") |>
  clean_names()

# uma olhadinha nos dados
data  |>
  glimpse()

figura <- data %>%
  ggplot() +
  aes(x = factor(date)) +
  geom_segment(aes(x=date, xend=date, y=low, yend=high)) +
  geom_point( aes(x=date, y=low), color="#007f7f", size=4 ) +
  geom_point( aes(x=date, y=high), color="orange", size=4) +
  theme_clean()+
  labs(title = "TÍTULO", subtitle="Subtitulo", x = "Dia", y = "Preço")

figura +
  theme(axis.title.y = element_text(size = 15), axis.title.x = element_text(size = 15), plot.title = element_text(size = 20, face = "bold"))
ggsave("figura.png", plot = figura)