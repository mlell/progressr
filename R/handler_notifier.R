#' Progression Handler: Progress Reported via the Operating-System Notification Framework (GUI, Text)
#'
#' A progression handler for `notify()` of the \pkg{notifier} package.
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/handler_notifier.R
#'
#' @section Requirements:
#' This progression handler requires the \pkg{notifier} package, which is only
#' available from <https://github.com/gaborcsardi/notifier>.  This can be
#' installed as `remotes::install_github("gaborcsardi/notifier@62d484")`.
#'
#' @keywords internal
#' @export
handler_notifier <- function(intrusiveness = getOption("progressr.intrusiveness.notifier", 10), target = "gui", ...) {
  ## Used for package testing purposes only when we want to perform
  ## everything except the last part where the backend is called
  if (!is_fake("handler_notifier")) {
    pkg <- "notifier"
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop("Package 'notifier' is not available. See ?progressr::handler_notifier() for installation instructions")
    }
    notifier_notify <- get("notify", mode = "function", envir = getNamespace(pkg))
  } else {
    notifier_notify <- function(...) NULL
  }

  notify <- function(step, max_steps, message) {
    ratio <- sprintf("%.0f%%", 100*step/max_steps)
    msg <- paste(c("", message), collapse = "")
    notifier_notify(sprintf("[%s] %s", ratio, msg))
  }

  reporter <- local({
    finished <- FALSE
    
    list(
      reset = function(...) {
        finished <<- FALSE
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        notify(step = state$step, max_steps = config$max_steps, message = state$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || progression$amount == 0 || config$times <= 2L) return()
        notify(step = state$step, max_steps = config$max_steps, message = state$message)
      },
        
      finish = function(config, state, progression, ...) {
        if (finished) return()
        if (!state$enabled) return()
        if (state$delta > 0) notify(step = state$step, max_steps = config$max_steps, message = state$message)
	finished <<- TRUE
      }
    )
  })
  
  make_progression_handler("notifier", reporter, intrusiveness = intrusiveness, target = target, ...)
}
