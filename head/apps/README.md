# USER APPLICATION INSTALLER

## How it works

Inside the _app-setup.sh_ script is an environmental variable `INSTALL_LIST`.

Use this variable to add all the applications names that you want to install to
the server. The application names must have the same **spelling** and **case**
as the names of the folders inside the apps directory.

In each of the app directories (e.g. <_git_directory_>/head/apps/torque), a
_setup.sh_ script needs to exist which contains a command to install all the
 necessary packages for compiling the software as well as actual the fetching,
  extracting and/or compilation of the software itself.

In other words:

Each of the app sub-directories can contain whatever amount of files and
directories as you want, as long as there is a _setup.sh_ in the root of the app
sub-directory.

## Multi-node apps

Once you're done with the setup procedure of the app on the headnode (as per
above), add a new role under the root ansible directory (<_git_directory_>/
head/ansible/roles) and follow the layout from the existing roles. Here you can
create a role that will do the networked stuff required to get your apps child
services to the nodes.

Once you've written the role, add it to the <_git_directory_>/head/ansible/
apps.yml file.
