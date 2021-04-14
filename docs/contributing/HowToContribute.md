# How to Contribute

---

## Contributing to Source Code

* Open a [GitHub Issue] in the repository to start a discussion.
* Pull the [GitHub Repository] and make a pull request with your changes.
    * Code will be reviewed and either merged or rejected with explanation.

## Contributing to the Documentation

Documentation is maintained using the same process as the source code.

* Open a [GitHub Issue] in the repository to start a discussion.
* Pull the [GitHub Repository] and make a pull request with your changes.
    * Documentation will be reviewed and either merged or rejected with explanation.

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
    or if using the optional [Shortcut Scripts]

    ```
    cd /<repo-location>
    mk serve
    ```

[MkDocs and Materials using Docker]: https://github.com/pages/donbeattie/OpenABL/contributing/MkDocsDocker/
[Shortcut Scripts]: ../MkDocsDocker/#using-shortcut-script
[GitHub Repository]: https://github.com/donbeattie/OpenABL
[GitHub Issue]: https://github.com/donbeattie/OpenABL/issues
