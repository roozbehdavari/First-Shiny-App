total.interest <- function(debt,apr,pay) 
{
  interest <- 0; interests <- c()
  apr.monthly <- (apr / 12) * 0.01
  while (debt > 0) {
    interest <- debt*apr.monthly + interest
    interests <- append(interests,interest)
    debt <- debt + debt*apr.monthly - pay
  }
interests
}

shinyServer(
  function(input, output) {  

    debt.serv <- reactive(as.numeric(input$debt))
    apr.serv <- reactive(as.numeric(input$apr))
    pay.serv <- reactive(as.numeric(input$pay))
    
    output$debt <- renderText({
      if (input$goButton == 0) 5000
      else debt.serv()})

    output$apr  <- renderText(apr.serv()) 
  
    output$pay <- renderText({
      if (input$goButton == 0) 250
      else pay.serv()})
    
    output$inter <- renderText({
      input$goButton
      isolate({
      if (input$goButton == 0) {debt.fun <- 5000 ; pay.fun <-250}
      else {debt.fun <- debt.serv() ; pay.fun <- pay.serv()}
          if (debt.fun * (apr.serv() / 12) * 0.01 >= pay.fun) 
              {print(paste('With this monthly payment you will never be able to pay off your debt! ',
                           'You need to increase your payment to at least $',
                           round(debt.fun * (apr.serv() / 12) * 0.01+0.01,2),'.',sep=''))}
          else{ round(max(total.interest(debt.fun,apr.serv(),pay.fun)),2) } 
      })
    })
    
    output$plot.inter <- renderPlot({
      input$goButton
      isolate({
        if (input$goButton == 0) {debt.fun <- 5000 ; pay.fun <-250}
        else {debt.fun <- debt.serv() ; pay.fun <- pay.serv()}
          if (debt.fun * (apr.serv() / 12) * 0.01 < pay.fun) {
            interest <- total.interest(debt.fun,apr.serv(),pay.fun) 
            plot(interest+debt.fun,ylab='True Cost ($)',xlab='Number of Payement Made',
                 main = 'Cumulative Cost over Months' , col='blue',cex.lab=1.5)}
        })
    })
    
    output$duration <- renderText({
      input$goButton
      isolate({
        if (input$goButton == 0) {debt.fun <- 5000 ; pay.fun <-250}
        else {debt.fun <- debt.serv() ; pay.fun <- pay.serv()}
        if (debt.fun * (apr.serv() / 12) * 0.01 < pay.fun) {
            nofMonths <- length(total.interest(debt.fun,apr.serv(),pay.fun))
            paste('You will be done with your payement in ',nofMonths,' months.',sep = '')}
      })
    })
    
    output$cost <- renderText({
      input$goButton
      isolate({
        if (input$goButton == 0) {debt.fun <- 5000 ; pay.fun <-250}
        else {debt.fun <- debt.serv() ; pay.fun <- pay.serv()}
        if (debt.fun * (apr.serv() / 12) * 0.01 < pay.fun) {
          nofMonths <- length(total.interest(debt.fun,apr.serv(),pay.fun))
          paste('True cost of purchase is $',
                round(max(total.interest(debt.fun,apr.serv(),pay.fun)) +debt.fun,2),'.',sep = '')}
      })
    
      })
    
  }
)