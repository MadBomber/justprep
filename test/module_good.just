# justprep/test/module_good.just

module modules/aaa/justfile
module modules/bbb/justfile

# Show Available Recipes
@list:
  just --list

# Show All Available Recipes including the Modules
@list_all: list aaa bbb
