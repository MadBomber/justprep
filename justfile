# github.com/MadBomber/justprep/**/justfile
#
# brew install just
# Handy way to save and run project-specific commands
# https://github.com/casey/just
#

set positional-arguments := true

# List available recipes
@list:
  echo
  echo "Available Recipes at"
  echo `pwd`
  echo "are:"
  echo
  just -l --list-prefix 'just ' --list-heading ''
  echo


# Compile the Crystal implementation
@compile:
  cd crystal && just compile


# Build the Ruby Gem
@build_gem:
  cd ruby && just build


# Show current source version
@show:
  cd ruby && just show


# Set the version to major.minor.patch
@set version:
  cd ruby && just set {{version}}


# Bump version level: major.minor.patch
@bump level:
  cd ruby && just bump {{level}}
