#' Create a list of Core files used in Atlantis
#'
#' Compiles a list of file names based on file extension (e.g. nc, txt, ts, xml, bgm)
#'
#' @param path Character string. Path to location of atlantis output files
#' @param filesToInclude Character vector. Types of files to copy (Default = ("txt","nc","ts","xml","bgm"))
#'
#' @return A character vector containing the names of all of the files to be copied to the google drive
#'
#' @export

get_files <- function(path= here::here(),filesToInclude = c("txt","nc","ts","xml","bgm")){

    fileList <- NULL
    for (aext in filesToInclude) {
      files <- list.files(path,paste0("*.",aext))
      fileList <- c(fileList,files)
    }

  return(fileList)

}
