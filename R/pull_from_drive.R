#' Renames, moves output files from google Drive to local machine
#'
#' Used for pulling archived Atlantis runs into the users workspace.
#'
#' @param idstr Character string. A file name/part of a file name or simply a string of characters associated with output filenames. This will be used to search for file names to pull if no files are listed in \code{fileList}
#' @param filePath Character string. Path to local Atlantis output directory. Files will be pulled to this directtory
#' @param fileList Character vector. Files names that need to be pulled from Google Drive. You can search filenames by substring instead. Set fileList = "match". All filenames that match in part the string \code{idstr} will be pulled
#' @param googledriveFolder Character String. Name of directory on google Drive to pull.
#' @param rootid Drive-id. Atlantis root id on google drive. (Default id for NEFSC is bundled in this package)
#'
#' @family googldrive functions
#'
#' @importFrom magrittr "%>%"
#'
#' @return Files are pulled to local drive
#'
#'@export

pull_from_drive <- function(idstr=NA, pathToOutput=here::here(),fileList="match",googledriveFolder=NULL, rootid=atlantisdrive::rootid){

  # Error checks ------------------------------------------------------------
  if (length(fileList) <=1)
    if ((length(fileList) == 1) & (fileList == "match"))
      if(is.na(idstr))
        stop("if fileList = \"match\" then idstr can not be NA")

  # googledrive folder cannot be empty\
  if (is.null(googledriveFolder))
    stop("You must specify a folder on google drive in which to pull files from. See googleDriveFolder argument")


  # Detect folders ----------------------------------------------------------

  # list the folders
  atlantisFiles <- googledrive::drive_ls(rootid)

  # check to see if folder is present
  if (any(googledriveFolder %in% atlantisFiles$name)) {
    message("Folder: ",googledriveFolder, "... found")

    # get id to googledriveFolder
    atlantisid <- atlantisFiles %>% dplyr::filter(name == googledriveFolder) %>%
      dplyr::select(id) %>%
      unlist() %>%
      googledrive::as_id(id)

  } else { # ask if need to create folder
    message(paste0("\n Folder: ",googledriveFolder, "... NOT found."))
    return(NULL)
  }


  # Pull files from drive ---------------------------------------------------

  # store list of files not present on drive
  allFiles <- googledrive::drive_ls(atlantisid)

  if (length(fileList) > 1) { # fileList will be a list of files

    for (afile in fileList) {
      filenameDribble <- allFiles %>% dplyr::filter(grepl(pattern=afile,name))
      filename <- filenameDribble$name
      fid <- filenameDribble$id

      googledrive::drive_download(googledrive::as_id(fid),path=file.path(pathToOutput,filename),overwrite=T)
    }

  } else if ((length(fileList) == 1) & (fileList == "match")) {
    # pull everyhing with id
    filesToPull <- allFiles %>% dplyr::filter(grepl(pattern=idstr,name))

    for (fid in filesToPull$id) {
      filename <- filesToPull %>%
        dplyr::filter(id==fid) %>%
        dplyr::select(name) %>%
        unlist()

      googledrive::drive_download(googledrive::as_id(fid),path=file.path(pathToOutput,filename),overwrite=T)
    }
  }


}
