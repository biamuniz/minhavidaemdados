library(tidyverse) #para lidar com os dados (ggplot tá aí!)
library(lubridate) #para lidar com as datas
library(weathermetrics) #para converter a temperatura
library(janitor) #clean_names
library(ggthemes) #outros temas


# create the object, then fill it with data from the csv
data <- read_csv("data-raw/3149757.csv") |>
  clean_names()

# peek at the data
data  |>
  glimpse()

data$tmin <- fahrenheit.to.celsius(data$tmin)
data$tmax <- fahrenheit.to.celsius(data$tmax)

data_clean <- data |> 
  select(
    date,
    tmax,
    tmin
  ) |>  
  filter(
    date > "2022-09-06")

data_clean <- data_clean |> 
  mutate(
    new_date= date)

data_clean |> 
  write_rds("data-processed/01-weather.rds")

figura <- data_clean %>%
  ggplot() +
  aes(x = factor(new_date)) +
  geom_segment(aes(x=new_date, xend=new_date, y=tmin, yend=tmax)) +
  geom_point( aes(x=new_date, y=tmin), color="#007f7f", size=4 ) +
  geom_point( aes(x=new_date, y=tmax), color="orange", size=4) +
  theme_economist()+
  labs(title = "TÍTULO", subtitle="Registros de temperaturas mínima e máxima em cada dia que estive em Austin, TX", x = "Dia", y = "Temperatura (°C)")
