..

Welcome to Artichoke's documentation!
=====================================


.. image:: https://readthedocs.org/projects/cmake-artichoke/badge/?version=latest
    :alt: status
    :scale: 100%
    :target: https://readthedocs.org/builds/cmake-artichoke/


You will find here a `CMake <http://cmake.org/>`_ module allowing to easily create a build system on top of `ExternalProject <http://www.cmake.org/cmake/help/git-master/module/ExternalProject.html>`_ module.


Features:

* Intuitive and easy way to "pass" CMake variables to any ExternalProject

* Receipe to write external project file for download, system or arbitrary location use

* Intuitive handling of USE_SYSTEM option

* Well-formatted summary of the included ExternalProject. For example, see `here <https://gist.github.com/jcfr/7990506>`_

* Experimental support for optional ExternalProject dependency based on inner project requirements


Contents:

.. toctree::
   :maxdepth: 2

   /ExternalProjectDependency


Usage
-----

Two possible approaches:

* Use `git submodule <(http://git-scm.com/docs/git-submodule>`_ to reference this repository.

* Copy `ExternalProjectDependency.cmake` into your source tree making sure you reference the SHA in the associated commit message.


Test
----

.. code-block:: bash

  sudo apt-get install cmake
  git clone git://github.com/commontk/Artichoke
  mkdir ArtichokeTest-build
  cd ArtichokeTest-build
  cmake ../Artichoke/Tests
  ctest


