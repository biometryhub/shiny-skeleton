##
## app.R
## shiny-skeleton
##
## Use of this source code is governed by the MIT license,
## a copy of which can be found in the LICENSE.md file.
##

library(shiny)
library(shinydashboard)

# Source all the files that you need for *this* file.
source('tabs/graphTab.R')

# Defines the root UI. Note that namespacing is not needed in this particular
# file, since we're currently defining the root of our application.
ui <- dashboardPage(skin = 'black',
  dashboardHeader(title = 'Shiny Skeleton'),
  dashboardSidebar(
    sidebarMenu(
      # Each tab module gets a `menuItem`,
      menuItem('Graph',
        icon = icon('chart-line'),
        tabName = 'graphTab'
      )
    )
  ),
  dashboardBody(
    tabItems(
      # a `tabItem`,
      tabItem('graphTab', graphTabUI('graph.tab'))
    )
  )
)

# Defines the root server function. Again, namespacing is not needed.
server <- function(input, output) {
  # and a `callModule` function call.
  callModule(graphTab, 'graph.tab')
}

# Runs the entire app.
shinyApp(ui, server)
