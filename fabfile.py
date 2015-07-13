import os
import sys

from fabric.api import task, local, run, lcd, env
from fabric.colors import red, green, yellow
from fabric.contrib.project import rsync_project

from fabric.context_managers import settings, hide

if "SENCHA_VERSION" not in os.environ:
    print(red("SENCHA_VERSION not set."))
    sys.exit(10)

ext_root = os.path.expanduser("~/develop/js/Sencha/ext-6.0.0")

# This is where sencha package add puts the .pkg file
local_repo = os.path.expanduser("~/Applications/Sencha/Cmd/repo/pkgs")

project_root = os.path.dirname(__file__)
workspace = os.path.join(project_root, "workspace")
package_build_dir = os.path.join(workspace, "build")


packages = ["nexiles-theme"]

env.user = "nexiles"
env.hosts = ["developer.nexiles.com"]


@task
def init():
    with settings(hide("stdout", "running")):
        print(green("Init workspace ..."))
        local("mkdir -p workspace")
        local("sencha -sdk {ext_root} generate workspace {workspace}".format(
            ext_root=ext_root,
            workspace=workspace))

        with lcd(workspace):
            for package in packages:
                print(green("Init package " + package + " ..."))
                local("sencha generate package {}".format(package))



@task
def build():
    for package in packages:
        print(green("Building " + package + " ..."))
        with settings(hide("stdout", "running")):
            with lcd("{workspace}/packages/local/{package}".format(
                    workspace=workspace,
                    package=package)):

                local("sencha package build")


@task
def add_to_local_repo():
    for package in packages:
        print(green("Adding " + package + " ..."))
        local("sencha package add {package_build_dir}/{package}/{package}.pkg".format(
            package_build_dir=package_build_dir,
            package=package))


@task
def sync_repo():
    print(green("Syncing repo ..."))
    rsync_project(
        remote_dir="/srv/packages/ext",
        local_dir=local_repo+"/")


# EOF
