% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{clusterJF}
\alias{clusterJF}
\alias{clusterJF.prcomp}
\alias{clusterJF.matrix}
\alias{clusterJF.tbl}
\title{Plot a cluster for JoesFlow}
\usage{
clusterJF(clustered_data, ...)

\method{clusterJF}{prcomp}(
  clustered_data,
  ids,
  meta,
  grp,
  colors,
  legend.name = "Group",
  show.legend = TRUE,
  ...
)

\method{clusterJF}{matrix}(
  clustered_data,
  axis_prefix = "axis",
  ids,
  meta,
  grp,
  colors,
  legend.name = "Group",
  show.legend = TRUE,
  ...
)

\method{clusterJF}{tbl}(
  clustered_data,
  meta,
  grp,
  colors,
  xlab,
  ylab,
  legend.name,
  show.legend = TRUE,
  ...
)
}
\arguments{
\item{clustered_data}{Object containing clustered data (expects output from `prcomp` or `uamp`)}

\item{...}{Other objects passed along to functions within clusterJF}

\item{ids}{Character vector of ids for each row in `clustered_data$x`, corresponding to labels in `meta`}

\item{meta}{Data frame containing metadata - first column corresponds to ids}

\item{grp}{Column of meta to use for grouping of data}

\item{colors}{Vector of colors for each group}

\item{legend.name}{Character string for the legend name (default is 'Group')}

\item{show.legend}{Logical value used to turn off the legend}

\item{axis_prefix}{x-and y-axis prefix (e.g. 'UMAP_')}

\item{xlab}{x-axis label}

\item{ylab}{y-axis label}
}
\value{
A ggplot object
}
\description{
Plot a cluster for JoesFlow
}
