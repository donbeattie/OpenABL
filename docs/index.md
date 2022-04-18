# Open ABL Project

---

## Objective

Supply OpenEdge ABL Libraries to extent OpenEdge capabilities.


## Setup Project (PDSOE)

The OpenABL repository is intentionally not setup as a PASOE project.
After cloning the repository:

* Update the project to be a __faceted project__ (Project Properties > Project Facets)
* Toggle on the __OpenEdge Facet__ (Project Properties > Project Facets)
* Add __src__ to the PROPATH (Project Properties > Progress OpenEdge > PROPATH)
* Add __gui/ablunit.pl__ or __tty/ablunit.pl__ to the PROPATH to allow executing the supplied unit tests.

!!! note "Note"
    Its recommended that you __Apply and Close__ between each step above (with the exception of the last two).


## Source Code

Source code for the various libraries can be found in the [src folder].

Code is organized in two primary folders, __abl__ and __test__.

* The __abl__ folder contains the libraries in their most basic form.
These libraries should be supported in any ABL application (Linux and Windows).
If the libraries require application level implementations to be injected, examples will be found in  __test__.

* The __test__ folder contains implementations or examples of using the libraries found in __abl__.


## Documentation

The source of the documentation, found in the [doc folder], is written using Markdown and compiled by MkDocs.
The compiled [documentation] is hosted in GitHub pages.

## How to Contribute

Its easy to [contribute] to the Open ABL Project.
You can modify and add libraries by making pull requests or just open an issue.

---

[src folder]: https://github.com/donbeattie/OpenABL/tree/master/src/
[doc folder]: https://github.com/donbeattie/OpenABL/tree/master/docs/
[contribute]: https://github.com/pages/donbeattie/OpenABL/contributing/HowToContribute/
[documentation]: https://donbeattie.github.io/OpenABL/
