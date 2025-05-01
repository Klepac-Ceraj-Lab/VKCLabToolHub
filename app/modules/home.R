# modules/home.R

home_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Home Page"),
    p("Welcome to the Home Page."),
    fluidRow(
      div(class = "gallery",
          tags$a(
            href = route_link("age_model_v1"),
            class = "spotify-card-link",
            style = "text-decoration: none; color: inherit; display: block;",
            spotify_card(
              "assets/Age-Model.png",
              "Age Model V1",
              "Estimate gut microbiome maturation in infants 2-18 months from MetaPhlAn3 profiles"
          )
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
