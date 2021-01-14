
<!-- README.md is generated from README.Rmd. Please edit that file -->

# atlantisdrive

<!-- badges: start -->

![deploy to github
pages](https://github.com/andybeet/atlantisdrive/workflows/deploy%20to%20github%20pages/badge.svg)
<!-- badges: end -->

Tools for moving Atlantis files to and from Google drive

## Installation

``` r
remotes::install_github("andybeet/atlantisdrive")
```

## Usage

``` r
library(atlantisdrive)
```

To view the list of files/folders under the root folder (as defined by
`id`) on Google drive use

``` r
get_file_list()
get_file_list(targetDir = "Development")
get_file_list(targetDir = "Development/Example")
```

To pull all files containing the string “ATLNT” from the “Development”
folder to your local machine (Note: partial matches to file names are
allowed)

``` r
pull_from_drive(localPath=here::here(),fileList="ATLNT",googledriveFolder="Development")
```

To push all files from your “output” folder in your current working
directory to the “Testing/Example” folder on Google drive (Note: partial
matches to file names are allowed). All files are overwritten.

``` r
push_to_drive(id=NULL, localPath=here::here("output"), fileList=NULL, googledriveFolder="Testing/Example", rootid=atlantisdrive::rootid, overwrite = TRUE)
```

Note: special case when `fileList = NULL`. All Atlantis core files are
pushed.

To push all files containing the string “xml” from your “output” folder
in your current working directory to the “Testing/Example” folder on
Google drive. Appends the string “climate” to beginning of all files

``` r
push_to_drive(id="climate", localPath=here::here("output"), fileList="xml", googledriveFolder="Testing/Example", rootid=atlantisdrive::rootid, overwrite = TRUE)
```

#### Legal disclaimer

*This repository is a scientific product and is not official
communication of the National Oceanic and Atmospheric Administration, or
the United States Department of Commerce. All NOAA GitHub project code
is provided on an ‘as is’ basis and the user assumes responsibility for
its use. Any claims against the Department of Commerce or Department of
Commerce bureaus stemming from the use of this GitHub project will be
governed by all applicable Federal law. Any reference to specific
commercial products, processes, or services by service mark, trademark,
manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of Commerce.
The Department of Commerce seal and logo, or the seal and logo of a DOC
bureau, shall not be used in any manner to imply endorsement of any
commercial product or activity by DOC or the United States Government.*
