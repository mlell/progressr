% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plyr_progress_progressr.R
\name{progress_progressr}
\alias{progress_progressr}
\title{Use Progressr with Plyr Map-Reduce Functions}
\usage{
progress_progressr(...)
}
\arguments{
\item{\ldots}{Not used.}
}
\value{
A named \link[base:list]{base::list} that can be passed as argument \code{.progress}
to any of \pkg{plyr} function accepting that argument.
}
\description{
A "progress bar" for \pkg{plyr}'s \code{.progress} argument.
}
\section{Limitations}{

One can use use \code{\link[doFuture:registerDoFuture]{doFuture::registerDoFuture()}} to run \pkg{plyr} functions
in parallel, e.g. \code{plyr::l_ply(..., .parallel = TRUE)}.  Unfortunately,
using \code{.parallel = TRUE} disables progress updates because, internally,
\pkg{plyr} forces \code{.progress = "none"} whenever \code{.parallel = TRUE}.
Thus, despite the \pkg{future} ecosystem and \pkg{progressr} would support
it, it is not possible to run \pkg{dplyr} in parallel \emph{and} get progress
updates at the same time.
}

\examples{
if (requireNamespace("plyr", quietly=TRUE)) {

  with_progress({
    y <- plyr::llply(1:10, function(x) {
      Sys.sleep(0.1)
      sqrt(x)
    }, .progress = "progressr")
  })
  
}

}
