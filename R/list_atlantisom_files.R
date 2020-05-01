#' List of Atlantis output files needed for atlantisom R package
#'
#' Compiles a list of file names based on user input scenario and required atlantisom inputs
#'
#' @param scenario Character vector. User specified model name/scenario portion of atlantis output filenames
#'
#' @return A character vector containing the names of all of the files to be copied to the google drive
#'
#' @family atlantisdrive functions
#'
#' @examples
#' \dontrun{
#' # create a list of atlantisom input files for Norweigan Barents Sea model
#' atlantisom_outfilelist(scenario="nordic_runresults_01")
#'
#' # create a list of atlantisom input files for California Current model
#' atlantisom_outfilelist(scenario="outputCCV3")
#'
#' }
#'
#' @export

list_atlantisom_files <- function(scenario) {

  fileList <- NULL
  fileList <- c(paste0(scenario, ".nc"),
                paste0(scenario, "CATCH.nc"),
                paste0(scenario, "PROD.nc"),
                paste0(scenario, "ANNAGEBIO.nc"),
                paste0(scenario, "ANNAGECATCH.nc"),
                paste0(scenario, "BiomIndx.txt"),
                paste0(scenario, "Catch.txt"),
                paste0(scenario, "CatchPerFishery.txt"),
                paste0(scenario, "DietCheck.txt"),
                paste0(scenario, "YOY.txt")
                )

  return(fileList)

}
