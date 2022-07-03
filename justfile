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

set positional-arguments    := true
set allow-duplicate-recipes := true

version_tag   := "VERSION"
version_file  := "ruby/lib/justprep/common/constants.crb"

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
@install: _install_rb _install_cr


###################################################

# Test both the Ruby Gem and the Crystal Executable using JUST and RUN
test: _prep build unit_tests test_just test_run


# Testomg the JUST pre-processor
test_just:
  #!/usr/bin/env bash

  echo "Integration Tests for JUST ..." > $RR/test/result_for_just.txt

  export JUSTPREP_FOR=just
  export JUSTPREP_FILENAME_OUT=${JUSTPREP_FOR}file

  cd $RR/test
  source test.s >> result_for_just.txt 2>&1
  result=`diff result_for_just.txt expected_for_just.txt`

  if [ "" = "$result" ] ; then
    echo "Tests PASSED"
  else
    echo "tests FAILED"
    echo $result
  fi


# Testomg the RUN pre-processor
test_run:
  #!/usr/bin/env bash

  echo "Integration Tests fpr RUN ..." > $RR/test/result_for_run.txt

  export JUSTPREP_FOR=run
  export JUSTPREP_FILENAME_OUT=${JUSTPREP_FOR}file

  cd $RR/test
  source test.s >> result_for_run.txt 2>&1
  result=`diff result_for_run.txt expected_for_run.txt`

  if [ "" = "$result" ] ; then
    echo "Tests PASSED"
  else
    echo "tests FAILED"
    echo $result
  fi


# Ruby unit tests on common Crystal/Ruby code
ruby_unit_test:
  #!/usr/bin/env bash
  original_name=$JUSTPREP_FILENAME_IN
  export JUSTPREP_FILENAME_IN=main.just

  cd $RR/ruby

  echo "Ruby ..."

  # redirecting stderr to stdout because of deprecation warnings
  rake test 2>&1 |\
    fgrep runs |\
    fgrep assertions |\
    fgrep failures |\
    fgrep errors |\
    fgrep skips

  export JUSTPREP_FILENAME_IN=$original_name


# Crystal unit tests on common Crystal/Ruby code
@crystal_unit_test:
  echo "disabled"

  #### !/usr/bin/env bash
  #### riginal_name=$JUSTPREP_FILENAME_IN
  #### xport JUSTPREP_FILENAME_IN=main.just
  ####
  #### d $RR/crystal
  ####
  #### cho "Crystal ..."
  ####
  #### rystal run \
  ####  ../ruby/lib/justprep/common/*.crb \
  ####  ../ruby/test/common_test.rb |\
  #### grep tests |\
  #### grep failures |\
  #### grep errors |\
  #### grep skips
  ####
  #### xport JUSTPREP_FILENAME_IN=$original_name


# Run the unit tests on the common methods in both implementations
unit_tests: ruby_unit_test crystal_unit_test


#################################################
## Recipes that deal with the source code version
## Version manager is handled by the "bump" gem

# Set the version: major . minor . patch
set_version version:
  #!/usr/bin/env bash
  old_version=`grep '^[ \t]*{{version_tag}}' $RR/{{version_file}}`
  sed -i -r "s/${old_version}/VERSION = \"{{version}}\"/" \
    $RR/{{version_file}}

# Show current version
@show_version:
  grep '^[ \t]*{{version_tag}}' $RR/{{version_file}}


###########################################
## Hidden Recipes


# Compile the Crystal implementation
@_build_cr:
  cd $RR/crystal && just compile


# Build the Ruby Gem
@_build_rb:
  cd $RR/ruby && just build


# Install the crystal version to its default directory
@_install_cr:
  cd $RR/crystal && just install


# Install the gem version locally
@_install_rb:
  cd $RR/ruby && just install


# Oreoare to test the latest build
@_prep: build
  rm -f $RR/test/justfile
  rm -f $RR/test/Runfile
