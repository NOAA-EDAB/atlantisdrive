
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

To list all Atlantis core files that currently reside in your working
directory

``` r
list_core_files(path=here::here())
#> character(0)
```

To list all files (from scenario “ATLNTS-1”) required for atlantisom.

``` r
list_atlantisom_files(scenario="ATLNTS-1")
#>  [1] "ATLNTS-1.nc"                 "ATLNTS-1CATCH.nc"            "ATLNTS-1PROD.nc"            
#>  [4] "ATLNTS-1ANNAGEBIO.nc"        "ATLNTS-1ANNAGECATCH.nc"      "ATLNTS-1BiomIndx.txt"       
#>  [7] "ATLNTS-1Catch.txt"           "ATLNTS-1CatchPerFishery.txt" "ATLNTS-1DietCheck.txt"      
#> [10] "ATLNTS-1YOY.txt"
```
