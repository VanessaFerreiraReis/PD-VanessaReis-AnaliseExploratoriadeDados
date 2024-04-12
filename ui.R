## Novo arquivo ui de Country data

library(dplyr)
library(tidyr)
library(data.table)
library(scales)
library(markdown)
library(shiny)
library(htmlwidgets)
library(shinyWidgets)
library(RColorBrewer)
library(knitr)
library(maps)



shinyUI(
  fluidPage(
    includeCSS("www/styles.css"),
    navbarPage("Vanessa Reis - Análise exploratória de dados",
                
               tabPanel("Análise de Países",
                        
                        
                        p("Gráfico de linhas sob seleção de variáveis"),
                        #Painel principa com plot de country_data por linha
                        mainPanel(plotOutput("country_data_linha")),
                        
                        #Layout em flow para melhor justaposicao das opcoes
                        flowLayout(
                          
                          #Selecao das variaveis na base country_data
                          varSelectInput(inputId = "variaveis_country_data_x", label = "Variável Eixo X:", data = country_data, multiple = FALSE),
                          
                          varSelectInput(inputId = "variaveis_country_data_y", label = "Variável Eixo Y:", data = country_data, multiple = FALSE),
                          
                          #Selecao de cores
                          selectInput(inputId = 'cor', label = 'Escolha uma cor:',
                                      choices = c("navyblue", "red", "gold"), selected = "navyblue"),
                        ),
                        
                        #Definindo o range do eixo x
                        numericRangeInput(inputId = "x_lim", label = "Insira valor mínimo e máximo para eixo x:",
                                          value = c(min(country_data$child_mort), max(country_data$child_mort))),
                        
                        #Definindo o range do eixo y
                        numericRangeInput(inputId = "y_lim", label = "Insira valor mínimo e máximo para eixo y:",
                                          value = c(min(country_data$child_mort), max(country_data$child_mort)))
               ),
               
    )
  )
)