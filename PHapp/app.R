library(shiny)
library(bslib)
library(tidyverse)
library(ggtda)
library(magick)
library(ragg)

ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "pulse"),
  titlePanel("Vietoris-Rips Filtration Animation"),
  sidebarLayout(
    sidebarPanel(
      numericInput(inputId = "seed", label = "Set Seed", value = 888, min = 1, max = 9999999),
      sliderInput(
        inputId = "points",
        label = "Number of points:",
        min = 1,
        max = 50,
        value = 5
      ),
      sliderInput(
        inputId = "radii",
        "Set Radii Range",
        min = 0,
        max = 10,
        value = c(0, 5)
      ),
      numericInput(
        inputId = "rseqlength",
        label = "Animation Frames",
        value = 100,
        min = 1,
        max = 1000
      ),
      radioButtons(
        inputId = "resolution",
        label = "Select resolution",
        choices = list("Low" = 100, "Medium" = 200, "High" = 300),
        selected = 100
      ),
      radioButtons(
        inputId = "fps",
        "Select FPS",
        choices = list("10" = 10, "20" = 20, "50" = 50),
        selected = 10
      )
    ),
    mainPanel(
      imageOutput("distPlot", height = "600px")
    )
  )
)

server <- function(input, output) {
  # Add all UI inputs that should trigger a re-render to this list
  animation_reactive <- eventReactive(
    list(input$seed, input$points, input$radii, input$rseqlength, input$resolution, input$fps),
    {
      showNotification("Generating animation...", duration = NULL, id = "anim_message")

      set.seed(input$seed)
      point_data <- tibble(
        x = runif(input$points, min = 0, max = 10),
        y = runif(input$points, min = 0, max = 10)
      )

      radii_seq <- seq(input$radii[1], input$radii[2], length.out = input$rseqlength)

      # A slightly more robust way to set plot limits
      max_radius <- input$radii[2]
      limits_x <- c(0 - max_radius, 10 + max_radius)
      limits_y <- c(0 - max_radius, 10 + max_radius)

      create_plot <- \(r, data) {
        ggplot(data = data, aes(x = x, y = y)) +
          coord_fixed(xlim = limits_x, ylim = limits_y) +
          geom_disk(radius = r, fill = "aquamarine3", alpha = 0.5) +
          geom_simplicial_complex(radius = r) +
          geom_point(size = 1) +
          labs(title = paste("Radius:", format(r, digits = 2))) +
          theme_bw()
      }

      # Convert resolution input to a number
      res_val <- as.numeric(input$resolution)
      res_val2 <- switch(input$resolution,
        "100" = 400,
        "200" = 600,
        "300" = 800
      )

      img_list <- map(radii_seq, \(.x) {
        p <- create_plot(.x, data = point_data)
        temp_path <- tempfile(fileext = ".png")
        # Use the input$resolution value
        ragg::agg_png(temp_path, width = res_val2, height = res_val2, res = res_val)
        print(p)
        dev.off()
        img <- image_read(temp_path)
        unlink(temp_path)
        return(img)
      })

      # Convert fps input to a number before passing it to image_animate
      animation <- image_join(img_list) |> image_animate(fps = as.numeric(input$fps))

      removeNotification(id = "anim_message")
      return(animation)
    }
  )

  output$distPlot <- renderImage(
    {
      anim <- animation_reactive()
      tmpfile <- tempfile(fileext = ".gif")
      image_write(anim, path = tmpfile)
      list(src = tmpfile, contentType = "image/gif", deleteFile = TRUE)
    },
    deleteFile = TRUE
  )
}

shinyApp(ui, server)
