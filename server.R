

library(tidyverse)
library(data.table)
library(scales)
library(markdown)
library(shiny)
library(zoo)
library(htmlwidgets)
library(shinyWidgets)
library(RColorBrewer)
library(knitr)
library(ggplot2)

shinyServer(function(input, output){
  
  # Verificando os nomes das colunas
  print(names(country_data))

  
  #Criando um evento reativo que gera um plot quando uma das ações relacionadas 
  #ao gráfico de linhas muda, sendo elas, eixos, cores, e variáveis
  plot_country_data_reativo <- eventReactive(c(input$variaveis_country_data_x, input$variaveis_country_data_y, input$cor, input$x_lim, input$y_lim),{
    
    #Plotando o gráfico com as definições do eixo x, de cores, etc.

    ggplot(data = country_data, aes_string(x = input$variaveis_country_data_x, y = input$variaveis_country_data_y)) +
      geom_point(aes(color = gdpp))+
      scale_colour_gradient(low = "lightblue", high = input$cor)+
      ggplot2::xlim(input$x_lim) + 
      ggplot2::ylim(input$y_lim) + 
      geom_smooth(method = "lm") + 
      theme_classic()
    
  })
  
  #Atualizando o range do x quando uma variável é trocada
  update_xlim <- eventReactive(c(input$variaveis_country_data_x),{
    if(length(input$variaveis_country_data_x) == 0) return(numericRangeInput(inputId = "x_lim", label = "Insira valor mínimo e máximo para eixo x:", value = c(min(country_data$child_mort), max(country_data$child_mort))))
    updateNumericRangeInput(inputId = "x_lim", value = c(min(country_data[,input$variaveis_country_data_x], na.rm = T), max(country_data[,input$variaveis_country_data_x], na.rm = T))) 
  })
  
  #Atualizando o range do y quando uma variável é trocada
  update_ylim <- eventReactive(c(input$variaveis_country_data_y),{
    if(length(input$variaveis_country_data_y) == 0) return(numericRangeInput(inputId = "y_lim", label = "Insira valor mínimo e máximo para eixo y:", value = c(min(country_data$child_mort), max(country_data$child_mort))))
    updateNumericRangeInput(inputId = "y_lim", value = c(min(country_data[,input$variaveis_country_data_y], na.rm = T), max(country_data[,input$variaveis_country_data_y], na.rm = T))) 
  })
  
  #Renderizando o plot construído iterativamente 
  output$country_data_linha <- renderPlot({
    #Controlando para o caso de não selecionar nenhuma variável, ou de a variável não ser numérica
    #De modo a não introduzir limites ao eixo y, para uma variável que não é numérica
    if (((length(input$variaveis_country_data_x) == 0) | (!is.numeric(unlist(country_data[,input$variaveis_country_data_x][1]))))|((length(input$variaveis_country_data_y) == 0) | (!is.numeric(unlist(country_data[,input$variaveis_country_data_y][1])))))
    {
      if((!is.numeric(unlist(country_data[,input$variaveis_country_data_x][1]))) & (length(input$variaveis_country_data_x) != 0)) return(ggplot(country_data, aes_string(x=input$variaveis_country_data_x, y = input$variaveis_country_data_y)) + geom_point() +   geom_point(aes(color = gdpp))+
                                                                                                                                           scale_colour_gradient(low = "lightblue", high = input$cor) + geom_smooth(method = "lm") + theme_classic())
      if((!is.numeric(unlist(country_data[,input$variaveis_country_data_y][1]))) & (length(input$variaveis_country_data_y) != 0)) return(ggplot(country_data, aes_string(x=input$variaveis_country_data_x, y = input$variaveis_country_data_y)) + geom_point() +    geom_point(aes(color = gdpp))+
                                                                                                                                           scale_colour_gradient(low = "lightblue", high = input$cor) + geom_smooth(method = "lm") + theme_classic())
      else return(ggplot(country_data, aes(x=child_mort, y = child_mort)) + geom_point() +   geom_point(aes(color = gdpp))+
                    scale_colour_gradient(low = "lightblue", high = input$cor) + geom_smooth(method = "lm"))
    }
    
    #Atualizando o eixo y
    update_ylim()
    #Atualizando o eixo x
    update_xlim()
    #Plotando o gráfico de linhas reativamente
    plot_country_data_reativo()
  })
})
