# .../examples/just_files/just_modules/test/main.just

include ../../.justfile

module version ../version.just

# Hi
@hello:
  echo "Hello World"
  echo "These are my common variables ..."
  echo
  echo "me .......... {{me}}"
  echo "home ........ {{home}}"
  echo "backup_dir .. {{backup_dir}}"
  echo "backup_file . {{backup_file}}"
  echo "my_backup ... {{my_backup}}"
  echo "project ..... {{project}}"
  echo
  echo "These are the sub-tasks from module version ..."
  just version
