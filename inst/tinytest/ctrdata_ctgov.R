## RH 2019-09-28

#### SETUP ####
# this file is called from various files

#### ctrLoadQueryIntoDb ####

# test
expect_message(
  tmp_test <- suppressWarnings(
    ctrLoadQueryIntoDb(
      queryterm = "2010-024264-18",
      register = "CTGOV",
      con = dbc)),
  "Imported or updated 1 trial",
  info = "ctrdata_euctr.R#16")

# test
expect_equal(tmp_test$n, 1L,
             info = "ctrdata_euctr.R#20")

# test
expect_equal(tmp_test$success, "NCT01471782",
             info = "ctrdata_euctr.R#24")

# test
expect_true(length(tmp_test$failed) == 0L,
            info = "ctrdata_euctr.R#28")

#### ctrLoadQueryIntoDb update ####

# new query
q <- paste0("https://clinicaltrials.gov/ct2/results?",
            "term=osteosarcoma&type=Intr&phase=0&age=0&lup_e=")

# test
expect_message(
  tmp_test <- suppressWarnings(
    ctrLoadQueryIntoDb(
      queryterm = paste0(q, "12%2F31%2F2008"),
      con = dbc)),
  "Imported or updated ",
  info = "ctrdata_euctr.R#43")

# manipulate history to test updating
# implemented in dbCTRUpdateQueryHistory
hist <- suppressWarnings(dbQueryHistory(con = dbc))
hist[nrow(hist), "query-term"] <-
  sub("(.*&lup_e=).*", "\\112%2F31%2F2009", hist[nrow(hist), "query-term"])

# convert into json object
json <- jsonlite::toJSON(list("queries" = hist))

# update database
nodbi::docdb_update(
  src = dbc,
  key = dbc$collection,
  value = data.frame("_id" = "meta-info",
                     "content" = as.character(json),
                     stringsAsFactors = FALSE,
                     check.names = FALSE))

# test
expect_message(
  tmp_test <- suppressWarnings(
    ctrLoadQueryIntoDb(
      querytoupdate = "last",
      con = dbc)),
  "Imported or updated",
  info = "ctrdata_euctr.R#70")

# test
expect_true(tmp_test$n > 2L,
            info = "ctrdata_euctr.R#74")

# test
expect_true(length(tmp_test$success) > 2L,
            info = "ctrdata_euctr.R#78")

# test
expect_true(length(tmp_test$failed) == 0L,
            info = "ctrdata_euctr.R#82")

#### ctrLoadQueryIntoDb results ####

# get results
result <- suppressWarnings(
  dbGetFieldsIntoDf(
    fields = c(
      "clinical_results.baseline.analyzed_list.analyzed.count_list.count",
      "clinical_results.baseline.group_list.group",
      "clinical_results.baseline.analyzed_list.analyzed.units",
      "study_design_info.allocation",
      "location"),
    con = dbc))

result$number_sites <- sapply(
  result$location,
  function(x) length(x[["facility"]][["name"]]))

# test
expect_true(sum(result$number_sites, na.rm = TRUE) > 30L,
            info = "ctrdata_euctr.R#102")

# test
expect_true("character" == class(result[[
  "clinical_results.baseline.analyzed_list.analyzed.count_list.count"]]),
  info = "ctrdata_euctr.R#108")

# test
expect_true("list" == class(result[[
  "clinical_results.baseline.group_list.group"]]),
  info = "ctrdata_euctr.R#113")

# test
expect_true(
  sum(nchar(dfListExtractKey(
    result,
    list(c("location", "name"))
  )),
  na.rm = TRUE) > 1000L,
  info = "ctrdata_euctr.R#122")


