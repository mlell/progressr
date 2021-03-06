% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/handler_notifier.R
\name{handler_notifier}
\alias{handler_notifier}
\title{Progression Handler: Progress Reported via the Operating-System Notification Framework (GUI, Text)}
\usage{
handler_notifier(
  intrusiveness = getOption("progressr.intrusiveness.notifier", 10),
  target = "gui",
  ...
)
}
\arguments{
\item{intrusiveness}{(numeric) A non-negative scalar on how intrusive
(disruptive) the reporter to the user.}

\item{target}{(character vector) Specifies where progression updates are
rendered.}

\item{\ldots}{Additional arguments passed to \code{\link[=make_progression_handler]{make_progression_handler()}}.}
}
\description{
A progression handler for \code{notify()} of the \pkg{notifier} package.
}
\section{Requirements}{

This progression handler requires the \pkg{notifier} package, which is only
available from \url{https://github.com/gaborcsardi/notifier}.  This can be
installed as \code{remotes::install_github("gaborcsardi/notifier@62d484")}.
}

\examples{
pkg <- "notifier"
if (requireNamespace(pkg, quietly = TRUE)) {

  handlers("notifier")
  with_progress({ y <- slow_sum(1:10) })
  print(y)
  
}
}
\keyword{internal}
