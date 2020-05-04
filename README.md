
<!-- README.md is generated from README.Rmd. Please edit that file -->

# atlantisdrive

<!-- badges: start -->

<!-- badges: end -->

Tools for moving Atlantis files to and from google drive

## Installation

``` r
remotes::install_github("andybeet/atlantisdrive",build_vignettes = TRUE)
```

## Usage

``` r
library(atlantisdrive)
```

To view the list of folders under the root folder on google drive. The
id of the root folder is lazily loaded with `atlantisdrive` and used as
the default argument

``` r
get_dirs()
#> Using an auto-discovered, cached token.
#> To suppress this message, modify your code or options to clearly consent to the use of a cached token.
#> See gargle's "Non-interactive auth" vignette for more details:
#> https://gargle.r-lib.org/articles/non-interactive-auth.html
#> The googledrive package is using a cached token for andrew.beet@noaa.gov.
#> # A tibble: 4 x 3
#>   name        id                                drive_resource   
#> * <chr>       <chr>                             <list>           
#> 1 testing     1AWUUKOpu9SPVedG41aOXEcBNH_dm2AHB <named list [33]>
#> 2 JUMB        1J6XEaWbElR6_-VU3KEFyPVnxDn6m7jp4 <named list [33]>
#> 3 Development 1OCb4ct37MtAY_bxFaTZ9o0X7D8bQ04MT <named list [33]>
#> 4 Scenarios   1UgZF89BM4NHHQg4pqdJJKmBWZ2O7miEK <named list [33]>
```

To view the content of one of these folders:

``` r
get_files(targetDir = "Development")
#> # A tibble: 1 x 3
#>   name                    id                               drive_resource  
#> * <chr>                   <chr>                            <list>          
#> 1 ATLNTS-1_20191212aDF.p~ 1EAQGUxqNvXFLfNevIxwEgraXyyUoX-~ <named list [40~
```

To pull files from this folder to your local machine (Note: partial
matches to file names are allowed)

``` r
pull_from_drive(localPath=here::here(),fileList="ATLNT",googledriveFolder="Development")
```

To push files from your current working directory to google drive (Note:
partial matches to file names are allowed). Push to “Development” folder
on google drive

``` r
push_to_drive(id=NULL, localPath=here::here(), fileList=NULL, googledriveFolder="Development", rootid=atlantisdrive::rootid, overwrite = TRUE)
```

Note: special case when `fileList = NULL`. All Atlantis core files are
pushed.

To list all Atlantis core files that currently reside in your working
directory

``` r
list_core_files(path=here::here())
#> character(0)
```

To list all files (from scenario “ATLNTS-1”) required for atlantisom.

``` r
list_atlantisom_files(scenario="ATLNTS-1")
#>  [1] "ATLNTS-1.nc"                 "ATLNTS-1CATCH.nc"           
#>  [3] "ATLNTS-1PROD.nc"             "ATLNTS-1ANNAGEBIO.nc"       
#>  [5] "ATLNTS-1ANNAGECATCH.nc"      "ATLNTS-1BiomIndx.txt"       
#>  [7] "ATLNTS-1Catch.txt"           "ATLNTS-1CatchPerFishery.txt"
#>  [9] "ATLNTS-1DietCheck.txt"       "ATLNTS-1YOY.txt"
```
