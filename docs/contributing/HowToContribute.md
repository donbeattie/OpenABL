# How to Contribute

---

## Contributing to Source Code

* Open a [GitHub Issue] in the repository to start a discussion.
* Pull the [GitHub Repository] and make a pull request with your changes.
    * I will review your changes and respond.

## Contributing to the Documentation

Once you've pulled the MkDocs and Materials container, pull the [GitHub Repository]
and use the the following commands to preview the site locally in your browser.

=== "MacOS/Linux"

    ```
    cd /<repo-location>
    docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material
    ```
    or if using the optional [Shortcut Scripts]

    ```
    cd /<repo-location>
    md serve
    ```

=== "Windows"

    ```
    cd /<repo-location>
    docker run --rm -it -p 8000:8000 -v "%cd%":/docs squidfunk/mkdocs-material
    ```
    or if using the optional shortcut scripts

    ```
    cd /<repo-location>
    mk serve
    ```


[MkDocs and Materials using Docker]: https://github.com/pages/donbeattie/OpenEdge/contributing/MkDocsDocker/
[Shortcut Scripts]: ../MkDocsDocker/#using-shortcut-script
[GitHub Repository]: https://github.com/donbeattie/OpenEdge
[GitHub Issue]: https://github.com/donbeattie/OpenEdge/issues
