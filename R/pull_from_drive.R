#' Renames, moves output files from google Drive to local machine
#'
#' Used for pulling archived Atlantis runs into the users workspace.
#'
#' @param id Character string. Name of task/scenario/id associated with output.
#' @param filePath Character string. Path to local Atlantis output directory. Files will be pulled to this directtory
#' @param fileList Character vector. Files that need to be pulled from Google Drive. (Default = "all")
#' @param googledriveFolder Character String. Name of directory on google Drive to pull.
#' @param rootid Drive-id. Atlantis root id on google drive. (Default id for NEFSC is bundled in this package)
#'
#' @family googldrive functions
#'
#' @importFrom magrittr "%>%"
#'
#' @return A vector of filenames. These are the files that were not present on Google Drive and were not pulled.
#'
#'@export

pull_from_drive <- function(id, pathToOutput=here::here("output"),fileList="all",googledriveFolder, rootid=atlantisdrive::rootid){

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

  }

  # Push files to folder. check if already present. overwrite?
  # store list of files not pushed
  filesNotPushed <- NULL
  for (afile in fileList) {
    uploadFile <- file.path(pathToOutput,afile)
    newName <- paste0(id,"_",afile)
    result <- tryCatch(
      {
        googledrive::drive_upload(uploadFile, path = atlantisid, name = newName, overwrite = overwrite)
        res <- TRUE
      },
      error = function(e){
        message(afile," already exists for task ",taskid)
        return(FALSE)
      } ,
      warning = function(w) return(FALSE)
    )
    if (!result) {
      filesNotPushed <- c(filesNotPushed,afile)
    }
  }

  # set permission on files. Maybe unneccessary

  return(filesNotPushed)

}
