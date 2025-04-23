# modules/about.R
about_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("About Page"),
    p("This page gives you some info about the app.")
  )
}

about_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # About page server logic here
  })
}
