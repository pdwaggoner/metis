% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metis.assumptions.R
\name{metis.assumptions}
\alias{metis.assumptions}
\title{metis.assumptions}
\usage{
metis.assumptions()
}
\value{
A list of assumptions
}
\description{
This function loads holds the different assumptions used throughout the metis package.
}
\details{
List of Assumptions
\itemize{
\item convEJ2TWh
\item convEJ2GW
\item conv1975USDperGJ22017USDperMWh
\item conv1975USDperGJ22017USDperMBTU
\item convertGgTgMTC
\item GWPType}
}
\examples{
library(metis)
a<-metis.assumptions()
a # will give full list of assumptions
}
\keyword{assumptions}
