# justprep/justfile
#
# brew install just
# Handy way to save and run project-specific commands
# https://github.com/casey/just
#
# By default the "just" CLI utility looks for a file named "justfile"
# in its current directory hiearchie.  Using "justprep" as a pre-processor
# (in an alias wrapper for example) the file "main.just" will be used
# to build a new "justfile" by incorporating various user defined modules.

# TODO: add some recipes that make sense at this level

list:
  echo
  just -l
  echo

compiler_the_crystall_version:
  cd crystal && just compile

do_a_local_install_of_ruby_gem:
  cd ruby && rake
