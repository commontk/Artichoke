Artichoke
=========

[CMake](http://www.cmake.org) module allowing to easily create a build system on top of [ExternalProjects](http://www.cmake.org/cmake/help/v2.8.12/cmake.html#module:ExternalProject)


Features
--------

* Intuitive and easy way to "pass" CMake variables to any ExternalProject

* Receipe to write external project file for download, system or arbitrary location use

* Intuitive handling of USE_SYSTEM option

* Well-formatted summary of the included ExternalProject

* Experimental support for optional ExternalProject dependency based on inner project requirements

API
---
* mark_as_superbuild
```
#! mark_as_superbuild(<varname1>[:<vartype1>] [<varname2>[:<vartype2>] [...]])
#!
#! mark_as_superbuild(
#!     VARS <varname1>[:<vartype1>] [<varname2>[:<vartype2>] [...]]
#!     [PROJECTS <projectname> [<projectname> [...]] | ALL_PROJECTS]
#!     [LABELS <label1> [<label2> [...]]]
#!     [CMAKE_CMD]
#!   )
#!
#! PROJECTS corresponds to a list of <projectname> that will be added using 'ExternalProject_Add' function.
#!          If not specified and called within a project file, it defaults to the value of 'SUPERBUILD_TOPLEVEL_PROJECT'
#!          Otherwise, it defaults to 'CMAKE_PROJECT_NAME'.
#!          If instead 'ALL_PROJECTS' is specified, the variables and labels will be passed to all projects.
#!
#! VARS is an expected list of variables specified as <varname>:<vartype> to pass to <projectname>
#!
#!
#! LABELS is an optional list of label to associate with the variable names specified using 'VARS' and passed to
#!        the <projectname> as CMake CACHE args of the form:
#!          -D<projectname>_EP_LABEL_<label1>=<varname1>;<varname2>[...]
#!          -D<projectname>_EP_LABEL_<label2>=<varname1>;<varname2>[...]
```

* ExternalProject_Include_Dependencies
```
#! ExternalProject_Include_Dependencies(<project_name>
#!     [PROJECT_VAR <project_var>]
#!     [EP_ARGS_VAR <external_project_args_var>]
#!     [DEPENDS_VAR <depends_var>]
#!     [USE_SYSTEM_VAR <use_system_var>]
#!     [SUPERBUILD_VAR <superbuild_var>]
#!   )
```
* ExternalProject_Add_Empty
```
#! ExternalProject_Add_Empty(<project_name>
#!     DEPENDS <depends>
#!   )
```

* ExternalProject_Message
```
#! ExternalProject_Message(<project_name> <msg> [condition])
```


Examples
--------

See [Slicer/SuperBuild/External_zlib.cmake@7c77269](https://github.com/Slicer/Slicer/blob/7c7726994f76266e5604a3a8eeb5fd28ed50a3bd/SuperBuild/External_zlib.cmake)

Slicer and CTK configure output: https://gist.github.com/jcfr/7990506

Usage
-----

Two possible approaches:

* Use [git submodule](http://git-scm.com/docs/git-submodule) to reference this repository.

* Copy `Artichoke.cmake` into your source tree making sure you reference the SHA in the associated commit message.


Test
----

```
sudo apt-get install cmake
git clone git://github.com/commontk/Artichoke
mkdir ArtichokeTest-build
cd ArtichokeTest-build
cmake ../Artichoke/Tests
ctest
```


Contributing
------------

1. [Fork][fk] Artichoke
2. Create a topic branch - `git checkout -b my-awesome-feature`
3. Hack, hack, hack
4. Push to your branch - `git push origin my-awesome-feature`
5. Create an [Issue][is] with a link to your branch
6. That's it!

[fk]: http://help.github.com/forking/
[is]: http://github.com/commontk/Artichoke/issues
