# extract_values.R
# Functions for extracting values from PCA, UMAP, TSNE, ... for plotting and download

#' extract_values
#' Extract values from PCA, UMAP, and tSNE
#'
#' @param clustered_data Object containing clustered data (expects output from `prcomp`, `umap`, or `tsne`)
#' @param ids Character vector of ids for each row in `clustered_data`, corresponding to labels in `grps`
#' @param meta Data frame containing translation from id to group
#' @param grp Character value identifying the column of `meta` to use for group identifier
#' @param cluster Data frame containing sample ID and the assigned kmeans cluster, as returned by `kmeaner()`
#' @param ... Other objects passed to methods of `extract_values`
#'
#' @return A tibble with values for SampleID, Group, Cluster, PC/vector 1, and PC/vector 2
#' @export
#' @import dplyr
#' @importFrom rlang .data
extract_values <- function(clustered_data, ...)
{
  UseMethod('extract_values')
}

# method for principal components object
#' @rdname extract_values
#' @method extract_values prcomp
#' @export
extract_values.prcomp <- function(clustered_data, ids, meta, grp, cluster = NULL, ...)
{
  extract_values(clustered_data$x, ids, meta, grp, cluster, ...)
}

# method for matrix object
#' @rdname extract_values
#' @method extract_values matrix
#' @export
extract_values.matrix <- function(clustered_data, ids, meta, grp, cluster = NULL, ...)
{
  # fix "no visible global function definition" warnings in devtools::check()
  # (can't use `.data$` inside of dplyr::select)
  SampleID <- Group <- X1 <- X2 <- NULL

  # create data.frame to return
  retval <- tibble(SampleID = ids,
                   X1       = clustered_data[,1],
                   X2       = clustered_data[,2])

  if(!is.null(cluster))
    retval$cluster <- cluster$grp

  # grouping labels
  meta_grps <- tibble(id = meta[,1] %>% unlist(),
                      grp = meta[,grp] %>% unlist())

  # get group labels
  if(nrow(meta_grps) == nrow(retval))         # Sometimes we get a list of groups for each row of clustered_data
  {
    # double check that these are sorted properly
    if( any(meta_grps$id != retval$SampleID))
      stop("Group and sample IDs are not sorted properly")

    retval$Group <- meta_grps$grp
  }else{                                      # other times we get a look up table with one row per sample ID
    retval <- retval %>%
      group_by(.data$SampleID) %>%
      mutate(Group = meta_grps$grp[meta_grps$id == unique(.data$SampleID)] %>%
               as.character()) %>%
      ungroup()
  }

  # put IDs at the front and return
  if(!is.null(cluster))
  {
    return(dplyr::select(retval, SampleID, Group, cluster, X1, X2))
  }else{
    return(dplyr::select(retval, SampleID, Group, X1, X2))
  }
}


#' extract_sb_values
#' Extract values from sample based PCA
#'
#' @param clustered_data Object containing clustered data (expects output from `prcomp`)
#' @param ids Character vector of ids for each row in `clustered_data$x`, corresponding to labels in `grps`
#' @param meta Data frame containing translation from id to group
#' @param grp Character value identifying the column of `meta` to use for group identifier
#' @param cluster Data frame containing sample ID and the assigned kmeans cluster, as returned by `kmeaner()`
#' @return a data frame with values for SampleID, Group, PC1, and PC2
#' @export
#' @import dplyr
extract_sb_values <- function(clustered_data, ids, meta, grp, cluster = NULL)
{
  # fix "no visible global function definition" warnings in devtools::check()
  # (can't use `.data$` inside of dplyr::select)
  SampleID <- Group <- PC1 <- PC2 <- NULL

  # pull principal components from sb_pca()
  retval <- tibble(SampleID = ids,
                   PC1      = clustered_data$x[,'PC1'],
                   PC2      = clustered_data$x[,'PC2']) %>%

    # add grouping information
    group_by(.data$SampleID) %>%
    mutate(Group = meta[,grp][meta[,1] == unique(.data$SampleID)] %>%
             as.character()) %>%
    ungroup() %>%

    dplyr::select(SampleID, Group, PC1, PC2)

  if(!is.null(cluster))
  {
    retval$cluster <- cluster$grp
  }

  retval
}


#' extract_sb_loadings
#' Extract loadings from sample based PCA
#'
#' @param clustered_data Object containing clustered data (expects output from `prcomp`)
#' @return a data frame with loadings for PC1 and PC2 for each Cluster
#' @export
#' @import dplyr
extract_sb_loadings <- function(clustered_data)
{
  # pull loadings from clustered_data
  tibble(Cluster = rownames(clustered_data$rotation),
         PC1     = clustered_data$rotation[,'PC1'],
         PC2     = clustered_data$rotation[,'PC2'])
}
