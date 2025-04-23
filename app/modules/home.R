# modules/home.R

home_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Home Page"),
    p("Welcome to the Home Page."),
    fluidRow(
      div(class = "gallery",
        spotify_card(
          "assets/Age-Model.png",
          "Age Model V1",
          "Estimate gut microbiome maturation in infants 2-18 months from MetaPhlAn3 profiles"
        ),
        spotify_card(
          "assets/Hesse-Hub.webp",
          "Hesse Hub",
          "Preconfigured linux containers for bioinformatics workshops, courses and tutorials"
        )#,
        # tags$img(src ="assets/Age-Model.png")
      )
    )
  )
}

home_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Home page server logic
  })
}
