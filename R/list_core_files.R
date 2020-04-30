#' List of Core files used in Atlantis
#'
#' Compiles a list of file names based on file extension (e.g. nc, txt, ts, xml, bgm)
#'
#' @param path Character string. Path to location of atlantis output files
#' @param filesToInclude Character vector. Types of files to copy (Default = ("txt","nc","ts","xml","bgm"))
#'
#' @return A character vector containing the names of all of the files to be copied to the google drive
#'
#' @family atlantisdrive functions
#'
#' @examples
#' \dontrun{
#' # create a list of all xml files in your projects "output" folder
#' list_core_files(path=here::here("output"),filesToInclude=c("xml"))
#'
#' # create a list of all xml and ts files in your projects "test" folder
#' list_core_files(path=here::here("test"),filesToInclude=c("xml","ts"))
#'
#' }
#'
#' @export

list_core_files <- function(path= here::here(),filesToInclude = c("txt","nc","ts","xml","bgm")){

    fileList <- NULL
    for (aext in filesToInclude) {
      files <- list.files(path,paste0("*.",aext))
      fileList <- c(fileList,files)
    }

  return(fileList)

}
