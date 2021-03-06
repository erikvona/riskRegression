% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/print.predictCox.R
\name{print.predictCox}
\alias{print.predictCox}
\title{Print Predictions From a Cox Model}
\usage{
\method{print}{predictCox}(x, digits = 3, ...)
}
\arguments{
\item{x}{object obtained with the function \code{predictCox}.}

\item{digits}{[integer, >0] indicating the number of decimal places.}

\item{...}{Passed to print.}
}
\description{
Print predictions from a Cox model.
}
\details{
to display confidence intervals/bands,
the \code{confint} method needs to be applied on the object.
}
\seealso{
\code{\link{confint.predictCox}} to compute confidence intervals/bands.
\code{\link{predictCox}} to compute the predicted cumulative hazard/survival.
}
