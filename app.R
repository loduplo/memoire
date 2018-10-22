library("shiny")
library("dplyr")
library("ggplot2")
library("lubridate")
library("dygraphs")
library("gridExtra")
library("zoo")

mesData <- read.csv2(file="prodConsoShiny.csv", fileEncoding = "UTF-8")
#traitement des dates pour consolider a la journÃ©e
mesData$Date <- lubridate::dmy_hm(mesData$Date)
mesData$DateJour <- lubridate::date(mesData$Date)

ui <- fluidPage(
  title = "Examples of DataTables",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "solaire"',
        checkboxGroupInput("show_vars", "Données disponibles à montrer:",
                           names(mesData), selected = names(mesData))
      ),
      conditionalPanel(
        'input.dataset === "hydraulique"',
        helpText("Click the column header to sort a column.")
      ),
      conditionalPanel(
        'input.dataset === "autoConso"',
        helpText("Display 5 records by default.")
      )
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("solaire", DT::dataTableOutput("mytable1")),
        tabPanel("hydraulique", DT::dataTableOutput("mytable2")),
        tabPanel("autoConso", DT::dataTableOutput("mytable3"))
      )
    )
  )
)


#################################################################################################
server <- function(input, output) {
  
  
  #selectionne 1000 lignes dans le fichier
  mesData2 = mesData[sample(nrow(mesData), 1000), ]
  
  # choix des colonnes à afficher : input$show_vars
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(mesData2[, input$show_vars, drop = FALSE])
  })
  
  # les colonnes triees sont colorees, css attache
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(mesData2, options = list(orderClasses = TRUE))
  })
  
  # customize la longueur du menu : 5,30 ou 50. affiche 15 lignes par page, par defaut
  output$mytable3 <- DT::renderDataTable({
    DT::datatable(iris, options = list(lengthMenu = c(5, 30, 50), pageLength = 15))
  })
  
}

shinyApp(ui, server)
