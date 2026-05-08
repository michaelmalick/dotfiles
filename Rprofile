## R config

## Options
options("menu.graphics" = FALSE) # no gui menus
options(repos = c(CRAN = "https://cran.r-project.org"))
options(datatable.print.nrows = 50)
options(languageserver.diagnostics = FALSE) # use jarl instead
options(radian.complete_while_typing = FALSE) # allow nvim auto-scroll


## Set quartz options
setHook(packageEvent("grDevices", "onLoad"), function(...) {
    grDevices::quartz.options(
        width = 4,
        height = 4,
        antialias = TRUE,
        pointsize = 12
    )
})
