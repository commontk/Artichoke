..

Welcome to Artichoke's documentation!
=====================================


.. image:: https://readthedocs.org/projects/cmake-artichoke/badge/?version=latest
    :alt: status
    :scale: 100%
    :target: https://readthedocs.org/builds/cmake-artichoke/

.. image:: https://circleci.com/gh/commontk/Artichoke.svg?style=svg
    :alt: status
    :scale: 100%
    :target: https://circleci.com/gh/commontk/Artichoke

.. image:: https://github.com/commontk/Artichoke/actions/workflows/CI.yml/badge.svg
    :alt: CI
    :scale: 100%
    :target: https://github.com/commontk/Artichoke/actions/workflows/CI.yml

Introduction
------------

You will find here a `CMake <https://cmake.org/>`_ module allowing to easily create a build system on top of `ExternalProject <https://cmake.org/cmake/help/git-master/module/ExternalProject.html>`_ module.


Features
--------

* Intuitive and easy way to "pass" CMake variables to external project. By default, variables are associated with
  ``CMAKE_CACHE_ARGS``.

* Support association of CMake variable with labels.

* Automatically associate variables with ``CMAKE_ARGS`` if a multi-configuration CMake generator is
  used and ``${CMAKE_CFG_INTDIR}`` is found in the value.

* Automatically set external options ``LIST_SEPARATOR``, ``CMAKE_GENERATOR``, ``CMAKE_GENERATOR_PLATFORM`` and ``CMAKE_GENERATOR_TOOLSET``.

* If CMake >= 3.24, set ``DOWNLOAD_EXTRACT_TIMESTAMP`` to ``1``. See `CMP0135 <https://cmake.org/cmake/help/latest/policy/CMP0135.html>`_

* If not explicitly enabled, ensure ``User Package Registry`` look up using ``find_*`` commands is disabled.

  * If CMake >= 3.16, set ``CMAKE_FIND_USE_PACKAGE_REGISTRY`` to ``OFF`` otherwise set ``CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY`` to ``ON``.

* Display a well-formatted and user friendly summary of the included external projects. For example, see `here <https://gist.github.com/jcfr/7990506>`_

* Support Ninja generator:

  * If supported, ``USES_TERMINAL_*`` options are always set to dependent projects.
  * The following variables are automatically propagated to all projects:

    * ``CMAKE_EXPORT_COMPILE_COMMANDS``
    * ``CMAKE_JOB_POOL_COMPILE``
    * ``CMAKE_JOB_POOL_LINK``
    * ``CMAKE_JOB_POOLS``


* Intuitive handling of USE_SYSTEM options.

* Recipe to write external project file that can be:

  * downloaded/configured/built/installed
  * and/or found on system using ``find_package(<projectname> ...)`` calls
  * and/or explicitly specified using ``-D<projectname>_DIR:PATH=...`` variables.

Examples
--------

.. note:: *To be documented*


Usage
-----

.. note:: *To be documented*


Integrating CMake Module in your project
----------------------------------------

Two possible approaches:

* Use `git submodule <(https://git-scm.com/docs/git-submodule>`_ to reference this repository.

* Copy `ExternalProjectDependency.cmake` into your source tree making sure you reference the SHA in the associated commit message.


API
---

.. toctree::
   :maxdepth: 2

   /ExternalProjectDependency


Test
----

.. code-block:: bash

  sudo apt-get install cmake
  git clone git://github.com/commontk/Artichoke
  mkdir ArtichokeTest-build
  cd ArtichokeTest-build
  cmake ../Artichoke/Tests
  ctest


