# Shiny Skeleton

> Spooky *and* scary.

## Getting Started

### Dependencies

In order to run the skeleton application, you'll at least the following
dependencies installed:

- `ggplot2` (`~3.1`)
- `shiny` (`~1.2`)
- `shinydashboard` (`~0.7.1`)

It will probably work with earlier and later versions, but you never know.

### Running the App

You can run it from within RStudio using the `Run App` button up the top right
of the source pane. Note that due to a bug in RStudio, you will not be able to
reload the app to view changes. Instead, stop and restart it each time.

Alternatively, it can be run from the command line:

```sh
Rscript app.R
```

### Understanding the Code

To understand the application, read the following three files in order:

1. [`app.R`](#appR)
2. [`tabs/graphTab.R`](#graphTabR)
3. [`inputs/waveformInput.R`](#waveformInputR)

#### `app.R`

This is where it all comes together. This file bootstraps the entire application
and allows it to run. Our main objective here is to define our root-level UI and
server functions. Since we're using `shinydashboard`, the UI itself is fairly
straightforward. Where it starts to get interesting is the tabs.

In this skeleton project, we define each tab as its own self-contained module
(more on that in a bit). Right now, all you need to know is that each module has
its *own* UI and server functions, just like this file. In order to use the
module as a tab, we need to do a few things here:

1. A dedicated `menuItem` needs to be added to the `sidebarMenu`. This
   `menuItem` gets a user-facing name, a [Font Awesome](https://fontawesome.com)
   icon, and a unique hidden name for the tab. This hidden name can be anything,
   as long as the same name is used in the next point...
2. A dedicated `tabItem` needs to be added to the `tabItems`. The `tabItem` gets
   a unique hidden name (matching the name used in the last point), and a UI
   element. Traditionally, this UI element could have been anything — but in
   this skeleton app we're going to pass it the UI function of the
   self-contained module we're setting up. Note the string that we pass the
   module's UI function. That string is actually the shiny id that we're
   assigning the module, since the module itself can be used like any other
   shiny object with inputs and outputs.
3. Finally, we need to load the module using `callModule` down in the server
   function. This call needs to be passed at least two arguments. First, it
   needs the server function of the self-contained module that we're setting up.
   Second, it needs the same shiny id that was passed to the module's UI
   function. Any additional arguments you pass here will be forwarded on to the
   module's server function.

That's it for the root level. You can add as many module tabs as you want using
the above procedure.

#### `graphTab.R`

This file contains the module code for our graph tab. Similarly, it has its own
UI and server functions that run independently of the root UI and server
functions.

The first thing of critical importance here is namespacing. Within a module's UI
function, every shiny id referenced should be done using the `ns` function for
that module. Usually, it is defined on the first line of the module's UI as
follows:

```R
exampleUI <- function(id) {
  ns <- NS(id)
  # ...
}
```

This causes all shiny ids referenced using the function to be prefixed with the
given namespace. For example, `ns <- NS('example'); ns('button')` returns
`'example-button'`. By doing this, we can ensure that we don't need to worry
about conflicting shiny ids across the scope of the entire app. We just need to
make sure that we don't reuse an id within the same module.

We are now going to use another entirely separate module. This module is not its
own tab however, it's just an input. We can easily use it within this module
just by using its UI function, as you'd expect. We give it a uniquely namespaced
shiny id, allowing us to put more than one of it to use on the same page (if
that made sense in our use case).

Of course, we also need to load that module down in the server function by using
`callModule`, similarly to what we did for this tab's module in the root server
function. Importantly, we're assigning the result of the call to a variable,
something we didn't do in the root server function. This is because the tab
module returns nothing, while our input module does (more on that soon). The
variable stored is actually a reactive function. It can be called within any
reactive context to access the module's current results.

If this all seems overwhelming, think of it like parent-child relationships. The
root of the app is parent to the graph tab module. The graph tab module is
parent to the waveform input module. A child can return results which only its
direct parent can use. If a child wanted to pass a result to a grandparent, its
parent would naturally need to pass the result onto its parent and so on.

That's all for the tab. Now onto the input module.

#### `waveformInput.R`

This one is fairly simple. In this instance, we're just defining a box with
three slider inputs. Down in the server function, they are returned as a list
within a reactive context. This is what actually gets accessed when you use the
function returned by a module's `callModule` call. At any time when that
function is called, you're going to receive the list returned here containing
the values at that moment in time.

#### Conclusion

We could have arbitrarily many modular tabs, using arbitrarily many modular
inputs. We could have tabs relying on none or many input results. We could even
have tabs returning results to be used by the root. Shiny modules allow us to
create a hierarchy of information passing, making it easier to facilitate code
reuse. Most importantly, it keeps our codebase nice and clean. *You want this.*

## License

This skeleton code is [MIT licensed](LICENSE.md).
