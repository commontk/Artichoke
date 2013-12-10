Artichoke
=========

[CMake](http://www.cmake.org) module allowing to easily create a build system on top of [ExternalProjects](http://www.cmake.org/cmake/help/v2.8.12/cmake.html#module:ExternalProject)


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
