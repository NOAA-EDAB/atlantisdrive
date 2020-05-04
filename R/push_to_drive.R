#' Pushes Atlantis output files to google Drive
#'
#' Used for archiving important Atlantis runs.
#'  During development stage: filenames will be prefixed using the Jira task number.
#'  Once operational: file can be prefixed using scenario, scenario id, or pushed to a scenario folder on google Drive
#'
#' @param id Character string. A prefix to be added to the name of all uploaded files. The name of task/scenario/id associated with output. Defualt = NULL (No prefix)
#' @param localPath Character string. Path to local Atlantis output directory. Files will be pushed from this directory
#' @param fileList Character vector. Files that need to be archived on Google Drive. Specify file names in their entirety. Alternatively any character string present in file name. Default = NULL (all core files are pushed, see \code{\link{get_files}}). (Special case. fileList = NA, ALL files are pushed!)
#' @param googledriveFolder Character String. Name of directory on google Drive to push. "Development" or "Scenarios" (Default = Development)
#' @param rootid Drive-id. Atlantis root id on google drive. (Default id for NEFSC is bundled in this package)
#' @param overwrite Boolean. Overwrite existing files in push (Default = FALSE. This is very time consuming)
#'
#' @family atlantisdrive functions
#'
#' @importFrom magrittr "%>%"
#'
#' @return A vector of filenames. These are the files that were already present on Google Drive and were not overwritten. If overwrite = TRUE, this will be NULL
#'
#'@examples
#'
#'\dontrun{
#'#'# Pushes all files containing the string "2008" to the Development Folder on googledrive from the output folder on your current project, adds the prefix "Basin-2000" to each file and overwites all files found on google drive
#'
#'push_to_drive(id="Basin-2008",fileList="2008",googledriveFolder="Development",overwrite=TRUE)
#'
#'# Pushes all xml files to the Development Folder on googledrive from the output folder on your current project, adds the prefix "ATLNTS-22" to each file and overwites all files found on google drive
#'
#'push_to_drive(id="ATLNTS-22",fileList="xml",googledriveFolder="Development",overwrite=TRUE)
#'
#'# Pushes all core Atlantis files to the Presentation folder on google drive (prompts user to creates folder if neccesary) from "test" folder in current project. Adds the prefix "NEFMC" to  all uploaded files, overwrites.
#'
#'
#'push_to_drive(id="NEFMC",localPath = here::here("test"),fileList=NULL,googledriveFolder="Presentation")
#'
#'# Pushes ALL files from "test" folder to "test" folder. No file prefix
#'push_to_drive(localPath = here::here("test"), fileList = NA, googledriveFolder = "test", overwrite=TRUE)
#'
#'
#'}
#'
#'
#'
#'@export

push_to_drive <- function(id=NULL, localPath=here::here("output"),fileList=NULL,googledriveFolder="Development", rootid=atlantisdrive::rootid, overwrite = FALSE){

  # Detect/create folders ---------------------------------------------------
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

  # Push Files to Drive ----------------------------------------------------
  # check if already present. overwrite?
  # store list of files not pushed
  if (is.null(fileList)) {# push all files
    filesToPush <- list_core_files(path = localPath)
  } else if (is.na(fileList)) {
    filesToPush <- list.files(path = localPath)
  } else if (length(fileList) == 1) { #either a single file or a string
    allFiles <- list.files(path = localPath)
    filesToPush <- allFiles[grepl(pattern=fileList,allFiles)]
  } else { #list of specific filenames
    filesToPush <- fileList
  }

  filesNotPushed <- NULL
  for (afile in filesToPush) {
    uploadFile <- file.path(localPath,afile)
    if (is.null(id)) {
      newName <- afile
    } else{
      newName <- paste0(id,"_",afile)
    }
    result <- tryCatch(
      {
        googledrive::drive_upload(uploadFile, path = atlantisid, name = newName, overwrite = overwrite)
        res <- TRUE
      },
      error = function(e){
        message(afile," already exists for task ",id)
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
