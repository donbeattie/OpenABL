# MkDocs and Material using Docker

MkDocs and Material using Docker containers and commands.


## Get the Docker Image

The official Docker is a great way to get up and running in a few minutes, as it
comes with all dependencies pre-installed. Pull the image for the `latest` version with:

```
docker pull squidfunk/mkdocs-material
```

## Verifying MkDocs/Docker Image

To verify that the MkDocs/Docker images in the previous step works, you can check
the version of MkDocs using the following command:

=== "MacOS/Linux"

    ```
    docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material --version    
    ```

    Results of the call will depend on the version contained in the current Docker container.
    ```
    mkdocs, version 1.1.2 from /usr/local/lib/mkdocs (Python 3.8)
    ```

=== "Windows"

    ```
    docker run --rm -it -v "%cd%":/docs squidfunk/mkdocs-material --version
    ```

    Results of the call will depend on the version contained in the current Docker container.
    ```
    mkdocs, version 1.1.2 from c:\local\python\mkdocs (Python 3.8)
    ```

## Creating a New Site

You can bootstrap your project documentation using the `mkdocs` executable.
Go to the directory where you want your project to be located and enter:

=== "MacOS/Linux"

    ```
    docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material new .
    ```

=== "Windows"

    ```
    docker run --rm -it -v "%cd%":/docs squidfunk/mkdocs-material new .
    ```

This will create the following structure:

```
.
├─ docs/
│  └─ index.md
└─ mkdocs.yml
```

## Previewing Documentation as it's Written

MkDocs includes a live preview server, so you can preview your changes as you
write your documentation. The server will automatically rebuild the site upon
saving and reload within the browser. Start it with:

=== "MacOS/Linux"

    ```
    docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material
    ```

=== "Windows"

    ```
    docker run --rm -it -p 8000:8000 -v "%cd%":/docs squidfunk/mkdocs-material
    ```

Point your browser to http://localhost:8000 to see the compiled documentation.
Use CTRL/Control-C to stop the server when done.

## Building Documentation

When you're finished editing, you can build a static site from your Markdown
files with:

=== "MacOS/Linux"

    ```
    docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material build
    ```

=== "Windows"

    ```
    docker run --rm -it -v "%cd%":/docs squidfunk/mkdocs-material build
    ```

The contents of this directory (./site) make up your project documentation.
The site can be hosted on GitHub Pages, GitLab Pages, a CDN of your choice or
your private web server.

## Deploy Documentation (GitHub Pages)

Manually deploy project documentation invoke the following command from the directory containing the mkdocs.yml file:

=== "MacOS/Linux"

    ```
    docker run --rm -it -v ~/.ssh:/root/.ssh -v ${PWD}:/docs squidfunk/mkdocs-material gh-deploy --force
    ```

=== "Windows"

    ```
    docker run --rm -it -v ~/.ssh:/root/.ssh -v "%cd%":/docs squidfunk/mkdocs-material gh-deploy --force
    ```

## Using Shortcut Script
The commands above are verbose and cumbersome to type. To alleviate this pain, [scripts] can be used to supply shortcuts. Below are [scripts] for both MacOS and Windows. The [scripts] can be named whatever is memorable but will need to be adjusted to reflect that name for the help option. The OS specific script needs to be placed in the sessions PATH. These [scripts] can be expanded or modified to allow more MkDoc features, but the basics are already supplied.

=== "MacOS/Linux"

    ```
    #!/bin/sh

    COMMAND="$1"
    OPTIONS="$2 $3 $4 $5 $6"

    case $COMMAND in
      version) docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material --version  ;;
      serve)   docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material  ;;
      build)   docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material build $OPTIONS  ;;
      deploy)  docker run --rm -it -v ~/.ssh:/root/.ssh -v ${PWD}:/docs squidfunk/mkdocs-material gh-deploy --force  ;;
      new)     docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material new .  ;;
      * )      echo "\033[1mNAME\033[0m"
               echo "  \033[1mmd\033[0m - Command shortcut for MkDocs running under Docker"
               echo ""
               echo "\033[1mSYNOPSIS\033[0m"
               echo "  \033[1mmd\033[0m \033[4mcommand\033[0m"
               echo ""
               echo "\033[1mCOMMANDS\033[0m"
               echo "  Supply one of the following commands to:"
               echo "    \033[1mhelp\033[0m    - Display this helpful information"
               echo "    \033[1mversion\033[0m - Display MkDocs version information"
               echo "    \033[1mserve\033[0m   - Run the built-in development server (http://localhost:8000) for the current directory (control-c will stop the server)"
               echo "    \033[1mbuild\033[0m   - Build the MkDocs documentation in the current directory"
               echo "    \033[1mdeploy\033[0m  - Deploy documentation to GitHub Pages from the current directory"
               echo "    \033[1mnew\033[0m     - Create a new MkDocs project in the current directory"
               echo ""
               exit 1 ;;
    esac
    ```

=== "Windows"

    ```
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
        echo   Supply one of the following options to:
        echo     help    - Display this helpful information
        echo     version - Display MkDocs version information
        echo     serve   - Run the built-in development server (http://localhost:8000) for the current directory (ctrl-c will stop the server)
        echo     build   - Build the MkDocs documentation in the current directory
        echo     deploy  - Deploy documentation to GitHub Pages from the current directory
        echo     new     - Create a new MkDocs project in the current directory
        echo.
    )

    goto :eof
    ```

The following is the syntax to use the [scripts] defined above. The MacOS version fo the script is named __md__, however the Windows version is named __mk__.bat because it confliced with the Windows __MD__ (MKDIR) command.

=== "MacOS/Linux"

    ```
    NAME  
      md - Command shortcut for MkDocs running under Docker

    SYNOPSIS
      md option (e.g. md serve)

    OPTIONS  
      Supply one of the following options to:
        help    - Display this helpful information
        version - Display MkDocs version information
        serve   - Run the built-in development server (http://localhost:8000) for the current directory (control-c will stop the server)
        build   - Build the MkDocs documentation in the current directory
        deploy  - Deploy documentation to GitHub Pages from the current directory
        new     - Create a new MkDocs project in the current directory
    ```

=== "Windows"

    ```
    NAME  
      mk - Command shortcut for MkDocs running under Docker

    SYNOPSIS
      mk option (e.g. mk serve)

    OPTIONS  
      Supply one of the following options to:
        help    - Display this helpful information
        version - Display MkDocs version information
        serve   - Run the built-in development server (http://localhost:8000) for the current directory (control-c will stop the server)
        build   - Build the MkDocs documentation in the current directory
        deploy  - Deploy documentation to GitHub Pages from the current directory
        new     - Create a new MkDocs project in the current directory
    ```

[scripts]: https://git.rockfin.com/AMP/CodingStandards/tree/master/src/scripts
