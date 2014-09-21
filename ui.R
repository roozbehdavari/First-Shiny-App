library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("The Interest Calculator App"),
  
  sidebarPanel(
    h5('This easy-to-use application helps you calculate the true cost of your 
        purchase and get insight into the your preferred monthly payment plan.'),
    textInput('debt','Credit Card Balance $:'),
    numericInput('apr', 'Annual Percentage Rate (APR) %:',value = 14, min = 1, max = 30, step = 0.5),
    textInput('pay','Monthly Payment $:'),
    actionButton("goButton", "Go!")
  ),
  
  mainPanel(
    p(em("Documentation:",a("Finding The Optimum Credit Card Payment Plan",href="index.html"))),
    p('Credit Card Balance $'),
    verbatimTextOutput('debt'),
    p('APR %'),
    verbatimTextOutput('apr'),
    p('Monthly Payment $'),
    verbatimTextOutput('pay'),
    p('Total Interest $'),
    verbatimTextOutput('inter'),
    verbatimTextOutput('duration'),
    verbatimTextOutput('cost'),
    plotOutput('plot.inter')
    )
))