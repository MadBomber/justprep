# ~/.justfile
# brew install just
# gem install justprep OR brew install justprep for the Crystal version
# alias jj='justprep && just'
#
# See: https://cheatography.com/linux-china/cheat-sheets/justfile/
#

# high-level just directives

set positional-arguments    := true
set allow-duplicate-recipes := true
set dotenv-load             := false

# my common variables

pwd         := env_var('PWD')

me          := justfile()
home        := env_var('HOME')
backup_dir  := env_var('JUST_BACKUP_DIR')
backup_file := trim_start_match(me, home)
my_backup   := backup_dir + backup_file
project     := `basename $RR`


# List available recipes
@list:
  echo
  echo "Available Recipes at"
  echo "$PWD"
  echo "are:"
  echo
  just -l --list-prefix 'jj ' --list-heading ''
  echo
  echo "jj <module_name> to see sub-tasks"
  echo


# Show help/usage for "just" command
help: list
  echo
  echo
  just --help


# Backup all changed just files to $JUST_BACKUP_DIR
@backup_all_just_files:
  backup_just.rb


#################################################
## Private recipes

# Show private recipes
@_show_private:     # Show private recipes
  grep -B 1 "^[@]_" {{justfile()}}


# Show the differences between this justfile and is last backup
@_just_diff_my_backup:
  # echo "me          -=> {{me}}"
  # echo "home        -=> {{home}}"
  # echo "backup_file -=> {{backup_file}}"
  # echo "my_backup   -=> {{my_backup}}"

  @diff {{me}} {{my_backup}}


# Replace current justfile with most recent backup
@_just_restore_me_from_backup:
  echo
  echo "Do this because I will not ..."
  echo
  echo "cp -f {{my_backup}} {{me}}"
  echo


# Edit the $JUSTPREP_FILENAME_IN file
@_just_edit_me:
  $EDITOR {{me}}
