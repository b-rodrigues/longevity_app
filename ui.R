ui <- function(request){
  fluidPage(
 
  fileInput("file", "Choose RDS file",
            accept = c("rds")),


  fluidRow(
    column(6,
           plotOutput("plot"),
           ),
    column(6,
           fluidRow(
             column(4,

                    pickerInput("condition", "Select type of condition:",
                                choices = c("error", "message", "warning", "Ok!"),
                                selected = "error",
                                options = list(`actions-box` = TRUE),
                                multiple = TRUE)
                    ),
             column(4,
                    pickerInput("version", "Select version:",
                                choices = NULL,
                                selected = NULL,
                                options = list(`actions-box` = TRUE),
                                multiple = TRUE
                                )
                    ),
             column(4,
                    pickerInput("scripts", "Select script:",
                                choices = NULL,
                                selected = NULL,
                                options = list(`actions-box` = TRUE),
                                multiple = TRUE
                                )
                    ),

             DTOutput("message")
           )
           )
  )


)
}
