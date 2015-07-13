.. _quickstart:

==========
Quickstart
==========


.. _quickstart_add_repo:

Adding the official nexiles ext package Repo
============================================

To use released packages, do::

  $ sencha package repo add nexiles http://developer.nexiles.com/packages/ext

That's all there is to setup.

Really Quick Start (Package Maintainers only)
=============================================

.. note:: This is for package maintainers only -- to actually **use** the packages
   you only need to add the nexiles package repo and add dependencies to the `app.json` file
   of your ExtJs project.

Clone the repo and::

  $ cd nexiles.ext.widgets
  $ virtualenv .
  $ . ./bin/activate
  $ . ./setenv.sh
  $ pip install -r requirements.txt
  $ fab init build

Links
=====

**Packages and Sencha CMD**
  - `packages intro`_
  - `creating packages`_

.. _packages intro:     http://docs.sencha.com/cmd/6.x/cmd_packages/cmd_packages.html
.. _creating packages:  http://docs.sencha.com/cmd/6.x/cmd_packages/cmd_creating_packages.html

