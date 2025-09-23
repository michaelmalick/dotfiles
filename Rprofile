## R config

## Options
options("menu.graphics" = FALSE)  # no gui menus
options(datatable.print.nrows = 50)


## Set quartz options
setHook(packageEvent("grDevices", "onLoad"),
    function(...)
        grDevices::quartz.options(width = 4,
                                  height = 4,
                                  antialias = TRUE,
                                  pointsize = 12))


## Hard code the US repo for CRAN
options(repos = c(CRAN = "https://cran.r-project.org"))
