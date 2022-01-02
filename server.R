
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)
library(scales)
library(ggsci)
library(stringr)

# Load College Major Data
#women.stem <- read.csv("women.stem.csv")
  
women.stem <- read.csv("womenstem1.csv")
  #read.csv(paste0("https://raw.githubusercontent.com/fivethirtyeight",
  #"/data/master/college-majors/women-stem.csv"))  # women in STEM degrees

recent.grads <- read.csv("recentgrads1.csv")
  #read.csv(paste0("https://raw.githubusercontent.com/fivethirtyeight",
    #"/data/master/college-majors/recent-grads.csv")) # All data for recent graduates


# Data Preparation
recent.grads <- na.omit(recent.grads)
recent.grads$Major <- str_to_title(recent.grads$Major)
recent.grads <- recent.grads %>% 
  mutate(Cat1=ifelse(Major_category %in% women.stem$Major_category, "STEM", "non-STEM")) %>%
  mutate(under=((Non_college_jobs+Low_wage_jobs)/(Non_college_jobs+Low_wage_jobs+College_jobs))) %>%
  mutate(popup1=paste0("Major: ", Major, "<br>",
                       "Major Sub-Category: ", Major_category, "<br>",
                       "Percent Female: ", round(ShareWomen*100, digits=2), "%","<br>",
                      "Median Salary: ", "$", Median, "<br>")) %>%
  mutate(popup2=paste0("Major: ", Major, "<br>",
                       "Major Sub-Category: ", Major_category, "<br>",
                       "Percent Female: ", round(ShareWomen*100, digits=2), "%","<br>",
                       "Unemployment Rate: ", round(Unemployment_rate*100, digits=2), "%", "<br>")) %>%
  mutate(popup3=paste0("Major: ", Major, "<br>",
                       "Major Sub-Category: ", Major_category, "<br>",
                       "Percent Female: ", round(ShareWomen*100, digits=2), "%","<br>",
                       "Under-Employment Rate: ", round(under*100, digits=2)))

x <- which(recent.grads$Major_category %in% women.stem$Major_category)
nonstem.data <- recent.grads[-x, ]
stem.data <- recent.grads[x,]

# Server Logic
shinyServer(function(session,input, output) {
  
  # Change sub category input based upon category selection
  observe({
    x <- recent.grads %>% filter (Cat1==input$stem) %>% 
      select(Major_category) %>% rename("Major Sub-Categories"=Major_category)
    y <- paste0("All ", input$stem, " Majors")
    updateSelectInput(session, "majorcat", "Major Sub-Categories", choices=c(y,unique(x)))
  })#observe event, changing submenu
  
  observe({
    x <- recent.grads %>% filter (Cat1==input$stem2) %>% select(Major_category)
    y <- paste0("All ", input$stem2, " Majors")
    updateSelectInput(session, "majorcat2", "Major Sub-Categories", choices=c(y,unique(x)))
  })#observe event2, changing submenu
 
  observe({
    x <- recent.grads %>% filter (Cat1==input$stem3) %>% select(Major_category)
    y <- paste0("All ", input$stem3, " Majors")
    updateSelectInput(session, "majorcat3", "Major Sub-Categories", choices=c(y,unique(x)))
  })#observe event3, changing submenu
  
  # Filter data based on input
  plotdata.sal <- reactive ({
    if (input$majorcat %in% recent.grads$Major_category) {
      filter.data <- recent.grads %>% filter (Major_category==input$majorcat)
    } else if (input$stem == "STEM" ) {
      filter.data <- recent.grads %>% filter(Cat1=="STEM")
    } else if (input$stem == "non-STEM") {
          filter.data <- recent.grads %>% filter(Cat1=="non-STEM")
    }
    return(filter.data)
    })

  # Salary Plot Render
  output$salaryplot <- renderPlotly({
              p <- ggplot(plotdata.sal(), aes(x=ShareWomen, y=Median, text=popup1, group=1))+
                geom_point(aes(color=Major_category), width=0.3, alpha=0.8)+
                geom_smooth(se=FALSE, color="black", size=0.5)+
                scale_fill_d3()+
                scale_x_continuous(labels=label_percent(), limits=c(0,1))+
                scale_y_continuous(labels=label_dollar())+
                theme_bw()+
                theme(legend.title=element_blank(),
                    panel.grid.major = element_line(color = "gray85"),
                    panel.grid.minor = element_line(color = "gray65"),
                    axis.title = element_text(face="bold", size=12, color="black"),
                    axis.text = element_text(size=10, color="black"),
                    panel.background = element_rect(size=0.25, color="black"),
                    legend.text = element_text(size=8))+
              labs(x = "\nPercent Female per Major Category", y = "Starting Salary \n", 
                    caption = paste0("Data Source:   https://github.com",
                                     "/fivethirtyeight/data/tree/master/",
                                   "college-majors"))
            
              plot<- ggplotly(p, tooltip='popup1')
         
             for (i in 1:length(plot$x$data)){
             if (!is.null(plot$x$data[[i]]$name)){
               plot$x$data[[i]]$name =  gsub("\\(","",str_split(plot$x$data[[i]]$name,",")[[1]][1])} # Plotly Legend "Bug"
              } # end for loop
             plot
          }) # End Sal Plot
  
  plotdata.unemploy <- reactive ({
    if (input$majorcat2 %in% recent.grads$Major_category) {
      filter.data <- recent.grads %>% filter (Major_category==input$majorcat2)
    } else if (input$stem2 == "STEM" ) {
      filter.data <- recent.grads %>% filter(Cat1=="STEM")
    } else if (input$stem2 == "non-STEM") {
      filter.data <- recent.grads %>% filter(Cat1=="non-STEM")
    }
    return(filter.data)
  })
  
  output$unemployplot <- renderPlotly({
    p <- ggplot(plotdata.unemploy(), aes(x=ShareWomen, y=Unemployment_rate, text=popup2, group=1))+
      geom_point(aes(color=Major_category), width=0.3, alpha=0.8)+
      geom_smooth(se=FALSE, color="black", size=0.5)+
      scale_fill_d3()+
      scale_x_continuous(labels=label_percent())+
      scale_y_continuous(labels=label_percent())+
      theme_bw()+
      theme(legend.title=element_blank(),
            panel.grid.major = element_line(color = "gray85"),
            panel.grid.minor = element_line(color = "gray65"),
            axis.title = element_text(face="bold", size=12),
            axis.text = element_text(size=10),
            legend.text = element_text(size=8))+
      labs(x = "\nPercent Female per Major Category", y = "Unemployment Rate \n", 
           caption = paste0("Data Source:   https://github.com",
                            "/fivethirtyeight/data/tree/master/",
                            "college-majors"))
    
    plot<- ggplotly(p, tooltip='popup2')
    
    for (i in 1:length(plot$x$data)){
      if (!is.null(plot$x$data[[i]]$name)){
        plot$x$data[[i]]$name =  gsub("\\(","",str_split(plot$x$data[[i]]$name,",")[[1]][1])} # Plotly Legend "Bug"
    } # end for loop
    plot
  }) # End Unemploy Plot
  
  plotdata.under <- reactive ({
    if (input$majorcat3 %in% recent.grads$Major_category) {
      filter.data <- recent.grads %>% filter (Major_category==input$majorcat3)
    } else if (input$stem3 == "STEM" ) {
      filter.data <- recent.grads %>% filter(Cat1=="STEM")
    } else if (input$stem3 == "non-STEM") {
      filter.data <- recent.grads %>% filter(Cat1=="non-STEM")
    }
    return(filter.data)
  })
  
  output$underplot <- renderPlotly({
    p <- ggplot(plotdata.under(), aes(x=ShareWomen, y=under, text=popup3, group=1))+
      geom_point(aes(color=Major_category), width=0.3, alpha=0.8)+
      geom_smooth(se=FALSE, color="black", size=0.5)+
      scale_fill_d3()+
      scale_x_continuous(labels=label_percent())+
      scale_y_continuous(labels=label_percent())+
      theme_bw()+
      theme(legend.title=element_blank(),
            panel.grid.major = element_line(color = "gray85"),
            panel.grid.minor = element_line(color = "gray65"),
            axis.title = element_text(face="bold", size=12),
            axis.text = element_text(size=10),
            legend.text = element_text(size=8))+
      labs(x = "\nPercent Female per Major Category", y = "Under-Employment Rate \n", 
           caption = paste0("Data Source:   https://github.com",
                            "/fivethirtyeight/data/tree/master/",
                            "college-majors"))
    
    plot<- ggplotly(p, tooltip='popup3')
    
    for (i in 1:length(plot$x$data)){
      if (!is.null(plot$x$data[[i]]$name)){
        plot$x$data[[i]]$name =  gsub("\\(","",str_split(plot$x$data[[i]]$name,",")[[1]][1])} # Plotly Legend "Bug"
    } # end for loop
    plot
  }) # End Sal Plot
  
}) # end server


