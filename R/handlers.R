#' Get and Set the List of Progression Handlers
#'
#' @param \dots One or more progression handlers.  Alternatively, this
#' functions accepts also a single vector of progression handlers as input.
#' If this vector is empty, then an empty set of progression handlers will
#' be set.
#'
#' @param on_missing (character) If `"error"`, an error is thrown if one of
#' the progression handlers does not exists.  If `"warning"`, a warning
#' is produces and the missing handlers is ignored.  If `"ignore"`, the
#' missing handlers is ignored.
#'
#' @return (invisibly) the previous list of progression handlers set.
#' If no arguments are specified, then the current set of progression
#' handlers is returned.
#'
#' @details
#' This function provides a convenient alternative for getting and setting
#' option \option{progressr.handlers}.
#'
#' @example incl/handlers.R
#'
#' @export
handlers <- function(..., on_missing = c("error", "warning", "ignore")) {
  args <- list(...)

  ## Get the current set of progression handlers?
  if (length(args) == 0L) return(getOption("progressr.handlers"))

  on_missing <- match.arg(on_missing)
  
  ## Was a list specified?
  if (length(args) == 1L && is.vector(args[[1]])) {
    args <- args[[1]]
  }

  handlers <- list()
  names <- names(args)
  for (kk in seq_along(args)) {
    handler <- args[[kk]]
    stop_if_not(length(handler) == 1L)
    
    if (is.character(handler)) {
      name <- handler
      name2 <- sprintf("%s_handler", name)
      
      handler <- NULL
      if (exists(name2, mode = "function")) {
        handler <- get(name2, mode = "function")
      }
      
      if (is.null(handler)) {
        if (exists(name, mode = "function")) {
          handler <- get(name, mode = "function")
        }
      }
      
      if (is.null(handler)) {
        if (on_missing == "error") {
          stop("No such progression handler found: ", sQuote(name))
	} else if (on_missing == "warning") {
          warning("Ignoring non-existing progression handler: ", sQuote(name))
	}
        next
      }

      names[kk] <- name
    }
    stop_if_not(is.function(handler), length(formals(handler)) >= 1L)
    handlers[[kk]] <- handler
  }
  stop_if_not(is.list(handlers))
  names(handlers) <- names

  ## Drop non-existing handlers
  keep <- vapply(handlers, FUN = is.function, FUN.VALUE = FALSE)
  handlers <- handlers[keep]

  options(progressr.handlers = handlers)[[1]]
}