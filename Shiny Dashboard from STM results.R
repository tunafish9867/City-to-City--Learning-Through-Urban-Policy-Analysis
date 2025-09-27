library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(tidyr)
library(stm)
library(tidytext)
library(reshape2)
library(bslib)
library(wordcloud)
library(shinydashboard)
library(wordcloud2)
library(igraph)
library(readxl)
library(thematic)
library(LDAvis)
library(DT)
library(jsonlite)
library(shinyjs)

# Load the STM models and precomputed topic results
load("final_stm_models_4.RData")
load("final_model_results_covariance_4.RData")
# Generate LDAvis JSON files
model_json <- toLDAvisJson(mod=model_egovCityAndCMCI, docs = out$documents, R=15, reorder.topics = FALSE)

thoughts <- read_excel("Thoughts_3.xlsx")

df <- data.frame(
  "Topic Number" = thoughts$`Topic Number`,
  "Ordinance Number" = thoughts$`Ordinance Number`,
  "Ordinance Description" = thoughts$`Ordinance Description`,
  "City" = thoughts$City,
  check.names = FALSE
)
topicNames <- c("FISHERIES", "INFRASTRUCTURE", "LOCAL DISASTER RISK AND REDUCTION MANAGEMENT", "BUSINESS AND TRADE REGULATIONS", "ORGANIZATIONAL STRUCTURE", "HEALTH AND SANITATION", "BARANGAY AFFAIRS AND BARANGAY DEVELOPMENT", "AWARD AND COMMENDATION", "BUSINESS AND TRADE REGULATIONS", "RULES AND REGULATIONS AND DECLARATION", "RULES AND REGULATIONS AND DECLARATION", "BUDGET MANAGEMENT AND ALLOCATION", "TOURISM AND CULTURE", "ORGANIZATIONAL STRUCTURE", "IMPOSITION OF PENALTIES", "IMPOSITION OF PENALTIES", "LAND USE AND ZONING", "BUSINESS AND TRADE REGULATIONS", "BUSINESS AND TRADE REGULATIONS", "ANIMAL WELFARE", "EDUCATION", "RULES AND REGULATIONS AND DECLARATION", "BUSINESS AND TRADE REGULATIONS", "EMPLOYEE BENEFITS AND EMPLOYEE WELFARE", "RULES AND REGULATIONS AND DECLARATION", "ORGANIZATIONAL STRUCTURE", "EDUCATION", "BUSINESS AND TRADE REGULATIONS", "YOUTH PROGRAMS", "RECURRING FESTIVITIES", "EMPLOYEE BENEFITS AND EMPLOYEE WELFARE", "BUDGET MANAGEMENT AND ALLOCATION", "IMPOSITION OF PENALTIES", "ROAD VEHICLE MANAGEMENT", "LAND USE AND ZONING", "RULES AND REGULATIONS AND DECLARATION", "RULES AND REGULATIONS AND DECLARATION", "GENDER AND SEXUALITY", "HEALTH AND SANITATION", "YOUTH PROGRAMS", "LAND USE AND ZONING", "ORGANIZATIONAL STRUCTURE", "FOOD SAFETY", "BARANGAY AFFAIRS AND BARANGAY DEVELOPMENT", "BUDGET MANAGEMENT AND ALLOCATION", "WASTE MANAGEMENT", "INFRASTRUCTURE", "GENDER AND SEXUALITY", "BUSINESS AND TRADE REGULATIONS", "ORGANIZATIONAL STRUCTURE", "WASTE MANAGEMENT", "AMMENDMENT", "BUDGET MANAGEMENT AND ALLOCATION", "BARANGAY AFFAIRS AND BARANGAY DEVELOPMENT", "ECOLOGY AND ENVIRONMENTAL PROTECTION", "ECOLOGY AND ENVIRONMENTAL PROTECTION", "LAND USE AND ZONING", "BUSINESS AND TRADE REGULATIONS", "BARANGAY AFFAIRS AND BARANGAY DEVELOPMENT", "ORGANIZATIONAL STRUCTURE", "ROAD VEHICLE MANAGEMENT", "FOOD PRODUCT SAFETY", "ORGANIZATIONAL STRUCTURE", "WASTE MANAGEMENT", "TRICYLCE PEDICAB FRANCHISING REGULATIONS", "ORGANIZATIONAL STRUCTURE", "ORGANIZATIONAL STRUCTURE", "EMPLOYEE BENEFITS AND EMPLOYEE WELFARE", "HEALTH AND SANITATION", "RULES AND REGULATIONS AND DECLARATION", "TERRITORIAL BOUNDARIES AND DISPUTES", "HEALTH AND SANITATION", "BUSINESS AND TRADE REGULATIONS", "SEXUAL HARRASSMENT", "ORGANIZATIONAL STRUCTURE", "SUBSTANCE REGULATION", "RULES AND REGULATIONS AND DECLARATION", "BUSINESS AND TRADE REGULATIONS", "UNCATEGORIZED", "LAND USE AND ZONING", "BUDGET MANAGEMENT AND ALLOCATION", "BUDGET MANAGEMENT AND ALLOCATION", "SENIOR CITIZEN", "LAND USE AND ZONING", "EMPLOYEE BENEFITS AND EMPLOYEE WELFARE", "RULES AND REGULATIONS AND DECLARATION", "URBAN DEVELOPMENT", "HEALTH AND SANITATION", "RULES AND REGULATIONS AND DECLARATION", "INFRASTRUCTURE", "TRICYLCE PEDICAB FRANCHISING REGULATIONS", "LAND USE AND ZONING", "LOCAL DISASTER RISK AND REDUCTION MANAGEMENT", "UNCATEGORIZED", "RULES AND REGULATIONS AND DECLARATION")


# Apply thematic styling
thematic_shiny(font = "auto")

# Define UI
ui <- page_navbar(
  title = "STM of City Ordinances Insights",
  theme = bs_theme(
    bg = "#F5F5F5", fg = "#607D8B", primary = "#607D8B",
    base_font = font_google("Roboto"),
    code_font = font_google("Roboto"),
    heading_font = font_google("Oswald")
  ),
  useShinyjs(),
  
  # Tab 1: About This Website
  nav_panel(
    "About This Website",
    fluidPage(
      h3("About this Website"),
      p("This website presents the results of an analysis of ordinances from 22 highly urbanized cities in the Philippines, based on data from the Department of Trade and Industry’s Competitiveness Index. Using a text analysis method, the site identifies common themes—or topics—across thousands of ordinances. Users can explore these topics through an interactive visualization that shows how they relate to one another and highlights the most important terms for each. The site also shows how these topics vary depending on a city’s competitiveness score, e-governance efforts, and location, with clear explanations provided for each factor. Lastly, users can view sample ordinances that best represent each topic, offering a closer look at how cities prioritize different issues through their local laws."),
      actionButton("model_exploration_button", "Go to Model Exploration"),
      actionButton("covariance_effect_button", "Go to Covariance Effect Exploration"),
      actionButton("document_representation_button", "Go to Document Representation"),
      br()
    )
  ),
  
  # Tab 2: Model Exploration
  nav_panel(
    "Model Exploration",
    actionButton("back_button_model", "Back to About This Website"),
    tabPanel("STM Model",
             fluidPage(
               h3("STM Model"),
               visOutput('modelChart')
             )
    )
  ),
  
  # Tab 3: Covariance Effect
  nav_panel(
    "Covariance Effect Exploration",
    actionButton("back_button_covariance", "Back to About This Website"),
    navbarPage("Covariance Effect Exploration", id = "covariance_tabs",
               tabPanel("E-Governance Index Covariance Effect",
                        fluidPage(
                          h3("Explore the Impact of E-Governance Index on City Ordinances"),
                          selectInput("topic", "Choose a topic:", choices = 1:95, selected = 1),
                          plotOutput("egovCovariance"),
                          p("The graph above illustrates the influence of e-governance, which refers to the use of digital technologies to deliver public services and manage government operations, on ordinances related to specific categories. The trend depicted in the graph indicates whether these particular ordinances are associated with high or low levels of e-governance. Understanding this is crucial because measuring e-governance helps identify how well the Philippines is integrating technology into public administration, which can improve efficiency, transparency, and citizen engagement.")
                        )),
               tabPanel("CMCI Score Index Covariance Effect",
                        fluidPage(
                          h3("Explore the Impact of CMCI Score on City Ordinances"),
                          selectInput("topic", "Choose a topic:", choices = 1:95, selected = 1),
                          plotOutput("cmciCovariance"),
                          p("The graph above displays how the Cities and Municipalities Competitive Index (CMCI) — an annual measure developed by the National Competitiveness Council to rank the competitiveness of Philippine cities and municipalities — impacts ordinances within a specific category. The trend line on the graph indicates whether these ordinances are associated with higher or lower CMCI scores. It's important to measure CMCI because it reflects the productivity and competitive edge of locations. In the Philippines, understanding CMCI helps improve local government operations and standards of living by highlighting areas that need enhancement in economic dynamism, government efficiency, infrastructure, resiliency, and innovation.")
                        )),
               tabPanel("City of Origin Covariance Effect",
                        fluidPage(
                          h3("Explore the Impact of the City of Origin on City Ordinances"),
                          selectInput("topic", "Choose a topic:", choices = 1:95, selected = 1),
                          plotOutput("cityCovariance")
                        )))
  ),
  
  #Tab 4: Document Representation
  nav_panel("Document Representation",
            fluidPage(
              actionButton("back_button_document", "Back to About This Website"),
              h3("Explore the Top 5 Most Representative Documents"),
              dataTableOutput("thoughtTable")
            )
  )
  
)

# Define server
server <- function(input, output, session) {
  observeEvent(input$model_exploration_button, {
    shinyjs::runjs('$(".nav a[data-value=\'Model Exploration\']").tab("show");')
  })
  
  observeEvent(input$covariance_effect_button, {
    shinyjs::runjs('$(".nav a[data-value=\'Covariance Effect Exploration\']").tab("show");')
  })
  
  observeEvent(input$document_representation_button, {
    shinyjs::runjs('$(".nav a[data-value=\'Document Representation\']").tab("show");')
  })
  
  # Observers for back buttons
  observeEvent(input$back_button_model, {
    shinyjs::runjs('$(".nav a[data-value=\'About This Website\']").tab("show");')
  })
  
  observeEvent(input$back_button_covariance, {
    shinyjs::runjs('$(".nav a[data-value=\'About This Website\']").tab("show");')
  })
  
  observeEvent(input$back_button_document, {
    shinyjs::runjs('$(".nav a[data-value=\'About This Website\']").tab("show");')
  })
  
  # Render the E-Governance STM Model chart
  output$modelChart <- renderVis({
    model_json
  })
  
  # Render the E-governance covariance effect plot
  output$egovCovariance <- renderPlot({
    topic_number <- as.numeric(input$topic)
    plot_title <- sprintf("HOW E-GOVERNANCE INFLUENCES ORDINANCES ON %s", topicNames[topic_number])
    plot.estimateEffect(egov_effect, covariate = "E-Governance Index", topics = topic_number, model = model_egovCityAndCMCI, method="continuous", main = plot_title, xlab = "E-Governance Index")
  })
  
  output$cmciCovariance <- renderPlot({
    topic_number <- as.numeric(input$topic)
    plot_title <- sprintf("HOW URBAN COMPETITIVENESS INFLUENCES ORDINANCES ON %s", topicNames[topic_number])
    plot.estimateEffect(cmci_effect, covariate = "Overall CMCI Score", topics = topic_number, model = model_egovCityAndCMCI, method="continuous", main=plot_title,xlab = "Urban Competitiveness (CMCI) Score")
  })
  output$cityCovariance <- renderPlot({
    topic_number <- as.numeric(input$topic)
    plot_title <- sprintf("WHAT CITY MIGHT THESE ORDINANCES ON %s ORIGINATE FROM", topicNames[topic_number])
    plot.estimateEffect(city_effect, covariate = "City", topics = topic_number, model = model_egovCityAndCMCI, method = "pointestimate",main=plot_title,xlab = "Effect of the city factor to the topic proportion",labeltype = "custom",custom.labels = c('Pasay','Iloilo','Paranaque','Cagayan de Oro','Las Pinas','Iligan','Caloocan','Muntinlupa','Davao','Pasig','Makati','Quezon','San Juan','Mandaluyong','Malabon','Manila','Bacolod','Mandaue','Valenzuela','Marikina','Gensan','Zamboanga'))
  })
  output$thoughtTable <- renderDataTable({
    datatable(df,options = list(
      pageLength = 25,         # Set 10 rows per page
      lengthChange = FALSE,    # Disable dropdown for changing number of rows
      searching = FALSE,       # Disable searching
      paging = TRUE,           # Enable pagination
      info = FALSE             # Disable table info text
    ),
    class = "display",          # Use default DT styling
    selection = "none",
    rownames = FALSE
    )
  })
}

# Combine UI and server to run the app
shinyApp(ui = ui, server = server)
