#' Renames, moves output files from Google Drive to local machine
#'
#' Used for pulling archived Atlantis runs into the users workspace.
#'
#' @param localPath Character string. Path to local Atlantis output directory. Files will be pulled to this directtory. Default = here::here()
#' @param fileList Character vector. Files name(s) that need to be pulled from Google Drive. Alternatively any character string present in file name
#' @param googledriveFolder Character String. Name of directory on google Drive to pull.
#' @param rootid Drive-id. Atlantis root id on google drive. (Default id for NEFSC is bundled in this package)
#'
#' @family atlantisdrive functions
#'
#' @importFrom magrittr "%>%"
#'
#' @return Files are pulled to local drive
#'
#'@examples
#'
#'\dontrun{
#'# Pulls all xml files from the Development Folder to your current working directory
#'pull_from_drive(fileList="xml",googledriveFolder="Development")
#'
#'# Pulls all files with the string "ATLNTS-2" present in its filename to the "output" folder in your project
#'pull_from_drive(localPath = here::here("output"),fileList="ATLNTS-2",googledriveFolder="Development")
#'
#'# Pulls selected files from the Scenario Folder
#' filesToPull <- c("file1.jpg","file2.txt","file3.bmg")
#'pull_from_drive(fileList=filesToPull,googledriveFolder="Scenario")
#'
#'}
#'
#'@export

pull_from_drive <- function(localPath=here::here(),fileList,googledriveFolder,rootid=atlantisdrive::rootid){

  # check if local folder is present
  if (!file.exists(localPath)){
    dir.create(localPath)
    message("Directory created:",localPath)
  }

  # Detect folders on google drive ----------------------------------------------------------
  target <- gd_exists(googledriveFolder,rootid)

  # check to see if folder is present
  if (target$isfound) {
    message("Folder: ",googledriveFolder, "... found")

    # get id to gogledriveFolder
    atlantisid <- target$id

  } else { # ask if need to create folder
    message(paste0("\n Folder: ",googledriveFolder, "... NOT found."))
    return(NULL)
  }


  # Pull files from drive ---------------------------------------------------

  # store list of files present on drive in googleDriveFolder
  allFiles <- googledrive::drive_ls(atlantisid)

  if(is.null(fileList)) { # pull all files

    for (ids in 1:length(allFiles$id)) {
      filename <- allFiles$name[ids]
      fid <- allFiles$id[ids]

      googledrive::drive_download(googledrive::as_id(fid),path=file.path(localPath,filename),overwrite=T)
    }

  } else if (length(fileList) > 1) { # fileList will be a list of files

    for (afile in fileList) {
      filenameDribble <- allFiles %>% dplyr::filter(grepl(pattern=afile,name))
      filename <- filenameDribble$name
      fid <- filenameDribble$id

      googledrive::drive_download(googledrive::as_id(fid),path=file.path(localPath,filename),overwrite=T)
    }

   } else if (length(fileList) == 1) {  # single file or a pattern to search

    filesToPull <- allFiles %>% dplyr::filter(grepl(pattern=fileList,name))

    for (fid in filesToPull$id) {
      filename <- filesToPull %>%
        dplyr::filter(id==fid) %>%
        dplyr::select(name) %>%
        unlist()

      googledrive::drive_download(googledrive::as_id(fid),path=file.path(localPath,filename),overwrite=T)
    }
  }


}
