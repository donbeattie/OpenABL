@echo off
setlocal

set OPTION=%1

IF        "%OPTION%"=="version" (
    docker run --rm -it -v %cd%:/docs squidfunk/mkdocs-material --version
) ELSE IF "%OPTION%"=="serve" (
    docker run --rm -it -p 8000:8000 -v %cd%:/docs squidfunk/mkdocs-material
) ELSE IF "%OPTION%"=="build" (
    docker run --rm -it -v %cd%:/docs squidfunk/mkdocs-material build
) ELSE IF "%OPTION%"=="deploy" (
    docker run --rm -it -v ~/.ssh:/root/.ssh -v %cd%:/docs squidfunk/mkdocs-material gh-deploy --force
) ELSE IF "%OPTION%"=="new" (
    docker run --rm -it -v %cd%:/docs squidfunk/mkdocs-material new .
) ELSE (
    echo NAME
    echo   mk - Command shortcut for MkDocs running under Docker
    echo.
    echo SYNOPSIS
    echo   mk option
    echo.
    echo OPTIONS
    echo   Supply one of the following options (in the root of a MkDocs project) to:
    echo     help    - Display this help syntax
    echo     version - Display MkDocs and Python versions
    echo     serve   - Run the built-in development server at http://localhost:8000 (use control-c will stop the server)
    echo     build   - Build the MkDocs documentation
    echo     deploy  - Deploy documentation to GitHub Pages
    echo     new     - Create a new MkDocs project
    echo.
)

goto :eof
