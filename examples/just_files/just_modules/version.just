## ~/just_modules/version.just
#
# Semantic Version Management
# gem install semver2
#
# Assumes that $RR is set to the repertory's root
#

version_path    := env_var("HOME")+"/just_modules/version.just"

# List the available sub-tasks in version module
@list:
  echo
  echo "Module version:"
  echo
  just -f {{version_path}} --list-prefix='jj version ' --list --list-heading=''
  echo


# Set the version into a project's VERSION constant
@set:
  echo
  echo "set is disabled"
  echo


# Initialize the .semver file for current project
init:
  #!/usr/bin/env bash
  cd $RR
  semver init


# Shows the current version
show:
  #!/usr/bin/env bash
  cd $RR
  semver


alias inc := bump

# Increments component. levels are major, minor, patch
bump level="patch":
  #!/usr/bin/env bash
  cd $RR
  semver inc {{level}}
  semver


# Sets the version "pre" component - like "alpha-23"
pre level="alpha":
  #!/usr/bin/env bash
  cd $RR
  semver pre {{level}}
  semver


# git --tag repository with the current version
tag:
  #!/usr/bin/env bash
  cd $RR
  # git --tag `semver tag`
  semver tag
