#' ctrdata: Overview on functions
#'
#' The ctrdata package provides functions to retrieve,
#' and to prepare for analysis, information on clinical
#' trials from public registers (EUCTR and CTGOV).
#' There are three categories of functions,
#' in sequence of their use in a workflow:
#'
#' @section Operations on a clinical trial register:
#'
#' \link{ctrOpenSearchPagesInBrowser},
#' \link{ctrFindActiveSubstanceSynonyms},
#' \link{ctrGetQueryUrlFromBrowser},
#' \link{ctrLoadQueryIntoDb}
#'
#' @section Using the database that holds downloaded information:
#'
#' \link{dbFindFields},
#' \link{dbQueryHistory}
#'
#' @section Get an R data frame from database, and operate on it:
#'
#' \link{dbGetFieldsIntoDf},
#' \link{dfMergeTwoVariablesRelevel},
#' \link{dfListExtractKey}.
#'
#' @section Deduplication:
#'
#' From the database, a vector of de-duplicated identifiers of
#' clinical trial records can be obtained with
#' \link{dbFindIdsUniqueTrials} and this can be used to select
#' subsets of interest from R dataframes.
#'
#' @docType package
#' @name ctrdata
#' @keywords internal
NULL
