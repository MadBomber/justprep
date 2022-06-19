# justprep/test/module_good.just

module aaa modules/aaa.just
module bbb modules/bbb.just

# Show Available Recipes
@list:
  just --list

# Show All Available Recipes including the Modules
@list_all: list aaa bbb
