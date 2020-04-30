#' Get list of directories on google drive
#'
#' Lists all folders under the root google drive folder
#'
#' @param rootid Drive-id. Atlantis root id on google drive. (Default id for NEFSC is bundled in this package
#'
#' @return A tibble containing folder names, id, etc
#'
#' @family atlantisdrive functions
#'
#' @examples
#'\dontrun{
#' # get list of directories under the root
#' get_dirs()
#'}
#'
#' @export

get_dirs <- function(rootid=atlantisdrive::rootid){

  dirs <- googledrive::drive_ls(googledrive::as_id(rootid))

  return(dirs)

}
