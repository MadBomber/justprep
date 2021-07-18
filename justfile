# github.com/MadBomber/justprep/**/justfile
#
# brew install just
#   Handy way to save and run project-specific commands
#   https://github.com/casey/just
#
# brew install direnv
#   Load/unload environment variables based on $PWD
#   https://direnv.net/
#
# SMELL:  Assumes that $RR is defined; well it is if the user
#         has direnv installed and its been allowed in this repo

set positional-arguments := true

# Displays this list of available recipes
help:
  #!/usr/bin/env bash
  echo
  echo "Available Recipes at"
  echo `pwd`
  echo "are:"
  echo
  just -l --list-prefix 'just ' --list-heading ''
  echo

  if [ "" = "$RR" ] ; then
    echo "================================================================="
    echo "== Set system environment variable 'RR' to the repository root =="
    echo "export RR=`pwd`"
    echo "================================================================="
  fi


# Build both Ruby Gem and Crystal versions
@build: _build_rb _build_cr


# Install both Ruby Gem and Crystal versions
@install: _install_rb _install_rb


# Test both the Ruby Gem and the Crystal Executable
test: _prep
  #!/usr/bin/env bash
  cd $RR/test
  source test.s > result.txt 2>&1
  result=`diff result.txt expected.txt`

  if [ "" = "$result" ] ; then
    echo "Tests PASSED"
  else
    echo "tests FAILED"
    echo $result
  fi


###########################################
## Version-related Recipes

# Show current source version
@version:
  cd $RR/ruby && just show


# Set the version to major.minor.patch
@set version:
  cd $RR/ruby && just set {{version}}


# Bump version level: major.minor.patch
@bump level:
  cd $RR/ruby && just bump {{level}}


###########################################
## Hidden Recipes


# Compile the Crystal implementation
@_build_cr:
  cd $RR/crystal && just compile


# Build the Ruby Gem
@_build_rb:
  # NOP - the rake install does the build


# Install the crystal version to its default directory
@_install_cr:
  cd $RR/crystal && just install


# Install the gem version locally
@_install_rb:
  cd $RR/ruby && just install


# Oreoare to test the latest build
@_prep: build install
  rm -f $RR/test/justfile
  rm -f $RR/test/result.txt
