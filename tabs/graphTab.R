##
## graphTab.R
## shiny-skeleton
##
## Use of this source code is governed by the MIT license,
## a copy of which can be found in the LICENSE.md file.
##

library(ggplot2)
library(shiny)

source('inputs/waveformInput.R')

graphTabUI <- function(id) {
  # A namespace must be used for all shiny id's within the module. This ensures
  # that every id is unique, even if the same names are used over different
  # modules. `ns <- NS('example'); ns('button')` returns `'example-button'`.
  ns <- NS(id)

  div(
    fluidRow(
      column(12,
        h2('Graph'),
        p("This is just an example module for this spooky app. Let's play around
          with a graph, just for fun."),
        hr()
      )
    ),
    fluidRow(
      column(12,
        # Here we use our `waveformInput` module. As always, it needs a unique
        # shiny id to distinguish it.
        waveformInput(ns('waveform.settings'))
      )
    ),
    fluidRow(
      column(12,
        plotOutput(ns('waveform.plot'))
      )
    )
  )
}

graphTab <- function(input, output, session) {
  # The `waveformInput` module's server function is called here, with the result
  # being stored as a variable. Within a reactive context, the result can be
  # called to retrieve its most current value.
  waveform.settings <- callModule(waveform, 'waveform.settings')

  output$waveform.plot <- renderPlot({
    wave <- function (x) {
      # Here we call the aforementioned reactive result, setting `ws` to a
      # standard list containing the module instance's current settings.
      ws <- waveform.settings()
      ws$amplitude * sin(ws$frequency * x + ws$phase.shift)
    }

    ggplot(data.frame(x = c(-5, 5)), aes(x)) +
      stat_function(fun = wave, n = 1000, size = 2)
  })
}
