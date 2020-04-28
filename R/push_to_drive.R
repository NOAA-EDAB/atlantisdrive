#' Pushes Atlantis output files to google Drive
#'
#' Used for archiving important Atlantis runs.
#'  During development stage: filenames will be prefixed using the Jira task number.
#'  Once operational: file can be prefixed using scenario, scenario id, or pushed to a scenario folder on google Drive
#'
#' @param id Character string. Name of task/scenario/id associated with output.
#' @param filePath Character string. Path to local Atlantis output directory. Files will be pushed from this directtory
#' @param fileList Character vector. Files that need to be archived on Google Drive
#' @param googledriveFolder Character String. Name of directory on google Drive to push. "Development" or "Scenarios" (Default = Development)
#' @param rootid Drive-id. Atlantis root id on google drive. (Default id for NEFSC is bundled in this package)
#' @param overwrite Boolean. Overwrite existing files in push (Default = FALSE. This is very time consuming)
#'
#' @family googldrive functions
#'
#' @importFrom magrittr "%>%"
#'
#' @return A vector of filenames. These are the files that were already present on Google Drive and were not overwritten. If overwrite = T, this will be NULL
#'
#'@export

push_to_drive <- function(id, pathToOutput=here::here("output"),fileList,googledriveFolder="Development", rootid=atlantisdrive::rootid, overwrite = F){

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
    response <- menu(c("yes","no"),title=paste0("Do you want to create a new folder with the name: ",googledriveFolder," ?"))
    if (response != "1") {
      stop("Aborted without any changes being made")
    } else {

    newFolder <- googledrive::drive_mkdir(name=googledriveFolder,path=googledrive::as_id(atlantisRootid))

    # get id to googledriveFolder
    atlantisid <- newFolder %>%
      dplyr::select(id) %>%
      unlist() %>%
      googledrive::as_id(id)
    }

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
