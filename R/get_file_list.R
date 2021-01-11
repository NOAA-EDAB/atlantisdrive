#' Get list of files with a directory on Google drive
#'
#' Lists all files under a directory on Google drive folder
#'
#' @param rootid Drive-id. The id to the root Atlantis Folder
#' @param targetDir Character. Path to a directory. Default = NULL - returns all files in root
#'
#' @return A tibble containing file name details
#' \item{name}{Folder/filename}
#' \item{id}{Drive id of folder/filename}
#' \item{drive_resource}{list of 33 objects defind in [googledrive](drive_ls)}
#'
#' @importFrom magrittr "%>%"
#'
#' @family atlantisdrive functions
#'
#' @examples
#'\dontrun{
#' # get list of files in the Scenario folder under the root
#' get_file_list()
#' get_file_list(targetDir = "Testing/Model1")
#' get_file_list(targetDir = "Scenario")
#' get_file_list(targetDir = "Scen")
#' get_file_list(targetDir = "ario")
#'
#'}
#'
#' @export

get_file_list <- function(rootid=atlantisdrive::rootid, targetDir=NULL){

  if(is.null(targetDir)) {
    id <- rootid
  } else if ((grepl("\\\\",targetDir)) | (grepl("/",targetDir))) {
    target <- gd_exists(targetDir,rootid)
    id <- target$id

    if (!target$isfound) {
      stop("Directory not found")
    }

  } else {
    dirs <- googledrive::drive_ls(googledrive::as_id(rootid))
    selectedDir <- dirs %>% dplyr::filter(grepl(pattern=targetDir,name))

    if (nrow(selectedDir) > 1) {
      message(paste(selectedDir$name,collapse=","))
      stop("Please refine targetDir. Multiple directories found")
    }

    id <- selectedDir$id
  }

  files <- googledrive::drive_ls(googledrive::as_id(id))

  return(files)

}
