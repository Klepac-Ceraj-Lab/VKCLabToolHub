spotify_card <- function(image_src, title, text, card_width = "18rem") {
  div(
    class = "spotify-card",  # wrapper class for additional CSS styling
    style = sprintf("width: %s; margin: 10px;", card_width),
    div(
      # class = "card",
      style = "border: none; background-color: transparent;",
      # Image container that forces a square shape with rounded corners
      div(
        class = "card-img-wrapper",
        tags$img(src = image_src, class = "card-img-top", alt = title)
      ),
      # Card body for the text content
      div(
        class = "card-body",
        tags$h5(class = "card-title", title),
        tags$p(class = "card-text", text)
      )
    )
  )
}
