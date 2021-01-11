#' Check if folder exists
#'
#' Checks to see if folder is already present.
#'
#' @param googledriveFolder Character String. Path to folder on Google Drive in which to push data.
#' @param rootid Drive-id. Root id on google drive in which \code{googleDriveFolder} is nested
#'
#' @family atlantisdrive functions
#'
#' @importFrom magrittr "%>%"
#'
#' @return A list of two items. If \code{googleDriveFolder} is present, its \code{id} is returned with \code{isfound} = T.
#' If  \code{googleDriveFolder} is not present then the \code{id} of the parent folder is returned with \code{isfound} = F
#' \item{id}{Drive-id for either the parent or child folder}
#' \item{isfound}{Boolean. Absence (F) or presence (T) of the target folder}
#'
#'@examples
#'\dontrun{
#' gd_exists(googledriveFolder="Testing/SampleRun", rootid=atlantisdrive::rootid)
#'}
#'
#'@export

gd_exists <- function(googledriveFolder,rootid) {

  foldersInLevel <- googledrive::drive_ls(rootid)
  # parse googledriveFolder
  googledriveFolder <- base::sub("\\\\","/",googledriveFolder)
  folders <- base::strsplit(googledriveFolder,"/")[[1]]

  isfound <- T
  # loop through file path to obtain id of nested folder
  for (adeep in folders) {

    # select next folder in path
    folderName <- foldersInLevel %>%
      dplyr::filter(name == adeep)


    if(dim(folderName)[1] == 0) {
      # more subfolders
      isfound <- F
      next

    } else {
      folderId <- foldersInLevel %>%
        dplyr::filter(name == adeep) %>%
        dplyr::select(id) %>%
        unlist() %>%
        googledrive::as_id(id)

      foldersInLevel <- googledrive::drive_ls(folderId)

    }
  }

  return(list(id=folderId,isfound=isfound))
}
