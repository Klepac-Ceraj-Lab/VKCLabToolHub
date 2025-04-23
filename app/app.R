library(shiny)
library(shiny.router)
library(bslib)
library(DBI)
library(RSQLite)
library(httr)
library(DT)

# Source your module files
source("custom_css.R")
source("modules/home.R")
source("modules/about.R")
source("modules/tools/age_model_v1.R")
source("components/spotify_card.R")

# Define the router UI – note that we don’t use make_router anymore
router <- router_ui(
  route("/", home_ui("home")),
  route("/about", about_ui("about")),
  route("/age_model_v1", age_model_v1_ui("age_model_v1"))
)

ui <- page_sidebar(
  header = "My bslib App",
  # Use a dynamic sidebar instead of a static one so we can leverage reactivity:
  sidebar = uiOutput("custom_sidebar"),
  theme = bs_theme(bootswatch = "flatly"),
  tags$head(custom_css),
  fluidPage(
    uiOutput("page_content"),  # where the current page UI will appear
  )
)

server <- function(input, output, session) {

  # Check if the URL hash is empty, and if so, redirect to "#!/home"
  observe({
    if (session$clientData$url_hash == "") {
      updateQueryString("#!/", mode = "push")
    }
  })

  # Reactive expression to capture the URL hash (e.g., "#!/home")
  current_route <- reactive({
    hash <- session$clientData$url_hash  # e.g., "#!/home"
    print(hash)
    # Remove the "#!" part:
    croute <- gsub("^#!", "", hash)
    # Remove the "#!" part:
    # croute <- unlist(strsplit(croute, split = "/"))[1]
    print(croute)
    return(croute)
  })

  output$current_route_debug <- renderPrint({
    current_route()
  })

  output$custom_sidebar <- renderUI({
    tagList(
      # Top block: logo and navigation buttons
      div(
        tagList(
          div(
            style = "margin-bottom: 30px; padding: 20px;",
            img(src = "assets/White-Trans.png", align = "center", width = "100%")
          ),
          div(
            style = "margin-bottom: 10px;",
            actionButton("nav_home", tagList(icon("home"), " Home"),
                         class = paste("custom-nav-btn w-100", if (current_route() == "home") "active" else ""))
          ),
          div(
            style = "margin-bottom: 10px;",
            actionButton("nav_about", tagList(icon("info-circle"), " About"),
                         class = paste("custom-nav-btn w-100", if (current_route() == "about") "active" else ""))
          ),
          div(
            style = "margin-bottom: 10px;",
            actionButton("nav_age_model_v1", "Age Model V1",
                         class = paste("custom-nav-btn w-100", if (current_route() == "age_model_v1") "active" else ""))
          )
        )
      ),
      # Separator
      div(
        style = "margin: 100 100 100 100; height: 100%; vertical-align: bottom; width: 0px;"
      ),
      # Bottom block: Footer content
      div(
        id = "sidebarFooter",
        style = "margin: 0; width: 100%; color: white; font-size: 0.9em; text-align: center;",
        div(
          img(src = "assets/White-Trans.png", align = "center", width = "50%")
        ),
        div(
          p("Some flavor text")
        )
      )
    )
  })

  # Update URL hash on navigation click
  observeEvent(input$nav_home, {
    updateQueryString("#!/", mode = "push")
  })

  observeEvent(input$nav_about, {
    updateQueryString("#!/about", mode = "push")
  })

  observeEvent(input$nav_age_model_v1, {
    updateQueryString("#!/age_model_v1", mode = "push")
  })

  # Render the page content based on current route, with a fallback to "home"
  output$page_content <- renderUI({
    switch(current_route(),
           "/"  = home_ui("home"),
           "/about" = about_ui("about"),
           "/age_model_v1" = age_model_v1_ui("age_model_v1")
    )
  })

  # Initialize each module's server logic
  home_server("home")
  about_server("about")
  age_model_v1_server("age_model_v1")
}

shinyApp(ui, server)
