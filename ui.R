# 
#setwd("~/Desktop/Final Project/Shiny Dashboard")
library(shiny)
library(shinydashboard)
library(plotly)

shinyUI(
    dashboardPage(title="Gender Bias",
                 
        dashboardHeader(title=span("Exploring Gender Bias in Starting Salaries and Unemployment", 
                                   style = "color: white; font-size: 28px;"), titleWidth = '99%'),
        
        dashboardSidebar(
            sidebarMenu(width=100,
                 menuItem(h4("Starting Salary"), tabName= "median"),
                 menuItem(h4("Unemployment Rate"), tabName = "unemploy"),
                 menuItem(h4("Under-Employment Rate"), tabName = "underemploy")
                            ) #sidebar menu
                         ), #dashboardsidebar
        dashboardBody(
            tags$head(tags$style(HTML('
                .skin-blue .main-header .logo {
                  background-color: #3c8dbc;
                }
                .skin-blue .main-header .logo:hover {
                  background-color: #3c8dbc;
                }'))),
                      tabItems(
                          tabItem(tabName = "median", status="primary",
                                 fluidRow(
                                     column(12, align="center",
                                            h3(strong("Choosing a Major - Economic Ramifications & Gender Bias")),
                                            h4("The following dashboard utilizes data from a American Community 
                                               Survey 2010-2012 Public Use Microdata Series to explore the impact of
                                               college major choice on starting salary and empolyment.  
                                               Of particular interest is strong evidence of gender bias on median
                                               starting salaries and choice of college major. 
                                               The reader is encouraged to explore these relationships further via the
                                               interactive visualizations below.")
                                            )
                                 ),
                                 
                                 fluidRow(
                                    column(8,
                                        h3(strong("Starting Salary")),
                                        box(plotlyOutput("salaryplot"), 
                                        status="primary", width=12)), # End Column
                                    column(4,
                                        fluidRow(
                                            column(12,
                                                h3(strong("Plot Filters")))), #end of row
                                        box(status = "primary", size=12,
                                            fluidRow(
                                            column(12,
                                                selectInput("stem", label="Major Category", 
                                                c(NULL, "STEM Major"="STEM", "non-STEM Major"="non-STEM",
                                                selected=NULL))
                                                    ) # end column
                                                ), #end row
                                        fluidRow(
                                            column(12,
                                                selectInput(inputId = "majorcat", 
                                                label="Major Sub-Category",
                                                choices= "",
                                                selected="")
                                                ) # end column
                                            ),# end row
                                        ) #endbox
                                    ) # end short column
                                ),
                                fluidRow(
                                    column(12,align="left",
                                           tags$i("A Shinydashboard by Owen R. Evans, DSA5200 Final Project"),
                                           tags$br(""),
                                           tags$a(href="https://github.com/fivethirtyeight/data/tree/master/college-majors",
                                                  "Data Source")
                                    ))# End row
                            ), # end tab item
                        
                      tabItem(tabName = "unemploy", status="primary",
                              fluidRow(
                                  column(12, align="center",
                                         h3(strong("Choosing a Major - Economic Ramifications & Gender Bias")),
                                         h4("The following dashboard utilizes data from a American Community 
                                               Survey 2010-2012 Public Use Microdata Series to explore the impact of
                                               college major choice on starting salary and empolyment.  
                                               Of particular interest is strong evidence of gender bias on median
                                               starting salaries and choice of college major. 
                                               The reader is encouraged to explore these relationships further via the
                                               interactive visualizations below.")
                                  )
                              ),
                                fluidRow(
                                      column(8,
                                             h3(strong("Unemployment Rate")),
                                             box(plotlyOutput("unemployplot"), 
                                                 status="primary", width=12)), # End Column
                                      column(4,
                                             fluidRow(
                                                 column(12,
                                                        h3(strong("Plot Filters")))),# end row
                                            box(status = "primary", size=12,
                                             fluidRow(
                                                 column(12,
                                                        selectInput("stem2", label="Major Category", 
                                                                    c(NULL, "STEM Major"="STEM", "non-STEM Major"="non-STEM",
                                                                      selected=NULL))
                                                 ) # end column
                                             ), #end row
                                             fluidRow(
                                                 column(12,
                                                        selectInput(inputId = "majorcat2", 
                                                                    label="Major Sub-Category",
                                                                    choices= "",
                                                                    selected="")
                                                 ) # end column
                                             ) # end row
                                         )# end box
                                      ) # end short column
                                  ),
                              fluidRow(
                                  column(12,align="left",
                                         tags$i("A Shinydashboard by Owen R. Evans, DSA5200 Final Project"),
                                         tags$br(""),
                                         tags$a(href="https://github.com/fivethirtyeight/data/tree/master/college-majors",
                                                "Data Source")
                                  ))# End bottom row #fluidrow
                             ),  #tabitem-unemploy
                          tabItem(tabName = "underemploy", status = "primary",
                                  fluidRow(
                                      column(12, align="center",
                                             h3(strong("Choosing a Major - Economic Ramifications & Gender Bias")),
                                             h4("The following dashboard utilizes data from a American Community 
                                               Survey 2010-2012 Public Use Microdata Series to explore the impact of
                                               college major choice on starting salary and empolyment.  
                                               Of particular interest is strong evidence of gender bias on median
                                               starting salaries and choice of college major. 
                                               The reader is encouraged to explore these relationships further via the
                                               interactive visualizations below.")
                                      )
                                  ),
                                  fluidRow(
                                      column(8,
                                             h3(strong("Under-employment Rate")),
                                             box(plotlyOutput("underplot"), 
                                                 status="primary", width=12)), # End Column
                                      column(4,
                                             fluidRow(
                                                 column(12,
                                                        h3(strong("Plot Filters")))), #end row
                                             box(status = "primary", size=12,
                                             fluidRow(
                                                 column(12,
                                                        selectInput("stem3", label="Major Category", 
                                                                    c(NULL, "STEM Major"="STEM", "non-STEM Major"="non-STEM",
                                                                      selected=NULL))
                                                 ) # end column
                                             ), #end row
                                             fluidRow(
                                                 column(12,
                                                        selectInput(inputId = "majorcat3", 
                                                                    label="Major Sub-Category",
                                                                    choices= "",
                                                                    selected="")
                                                 ) # end column
                                             ) # end row
                                          ) # end box
                                      ) # end short column
                                  ), # end of row
                                  fluidRow(
                                      column(12,align="left",
                                             tags$i("A Shinydashboard by Owen R. Evans, DSA5200 Final Project"),
                                             tags$br(""),
                                             tags$a(href="https://github.com/fivethirtyeight/data/tree/master/college-majors",
                                                    "Data Source")
                                      ))
                              ) #end of tab item
                          )#tabitems
                      )#dashboardbody
                )#dashboardpage
    )#shinyUI


