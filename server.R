server <- function(input, output, session) {

  # Load data from uploaded RDS file
  data <- reactive({
    req(input$file)
    readRDS(input$file$datapath) %>%
      decode_wontrun() %>%
      ungroup() %>%
    mutate(which_cnd = case_when(grepl("error", classes) ~ "error",
                                 grepl("message", classes) ~ "message",
                                 grepl("warning", classes) ~ "warning",
                                 TRUE ~ "OK!"),
           which_cnd = fct_relevel(which_cnd, "error", "warning", "message", "OK!"))

  })


  data_for_plot <- reactive({
    data() %>%
      group_by(version, which_cnd) %>%
      summarise(n = n()) %>%
      group_by(version) %>%
      mutate(total = sum(n),
             freq = n/total) %>%
      ungroup()

  })


  data_for_message <- reactive({
    data() %>%
      filter(#scripts %in% input$script,
      #       version %in% input$version,
             which_cnd %in% input$condition)
  })

  observe({
    updatePickerInput(session,
                      inputId = "scripts",
                      choices = unique(data_for_message()$scripts))

    updatePickerInput(session,
                      inputId = "version",
                      choices = unique(data_for_message()$version))
  })

  output$table <- renderDT({
    data_for_plot()
  })

  output$plot <- renderPlot({

    ggplot(data_for_plot(),
           aes(x = version,
               y = freq,
               fill = which_cnd)) +
    geom_col() +
      labs(title = "Proportion of Conditions per Version",
           x = "Version",
           y = "Frequency") +
      guides(y = guide_axis(n.dodge = 2)) +
      coord_flip()
  },
  height = 800,
  res = 74*1.5)

  # Display message from "runs" column
  output$message <- renderDT({
    data_for_message() %>%
      filter(version %in% input$version,
             scripts %in% input$scripts) %>%
      select(version, scripts, which_cnd, message)
  })

}
