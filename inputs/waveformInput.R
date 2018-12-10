##
## waveformInput.R
## shiny-skeleton
##
## Use of this source code is governed by the MIT license,
## a copy of which can be found in the LICENSE.md file.
##

library(shiny)
library(shinydashboard)

# Note that additional `label` parameter used here. These UI functions are just
# normal functions, so you can do whatever you want. The same thing can be done
# with server functions, but the arguments need to be called with names as a
# part of the `callModule` call.
waveformInput <- function(id, label = 'Waveform Settings') {
  ns <- NS(id)

  box(title = label, width = NULL,
    fluidRow(
      column(4,
        sliderInput(ns('amplitude'), 'Amplitude', 1, 25, 1)
      ),
      column(4,
        sliderInput(ns('frequency'), 'Frequency', 1, 25, 1)
      ),
      column(4,
        sliderInput(ns('phase.shift'), 'Phase Shift', 1, 25, 1)
      )
    )
  )
}

waveform <- function(input, output, session) {
  # A reactive result can be returned from a module. If that result is captured
  # with corresponding `callModule` calls, the result can then be accessed from
  # those contexts reactively.
  return(
    reactive({
      list(
        amplitude = input$amplitude,
        frequency = input$frequency,
        phase.shift = input$phase.shift
      )
    })
  )
}
