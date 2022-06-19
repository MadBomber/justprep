# .../modules/bbb.just

# Module bbb
@_bbb:
  echo 'Module bbb'
  just --list

# Do something magical
@xyzzy thing='rabbit':
  echo "Magic from bbb ..."
  echo "... watch me pull a {{thing}} out of my hat."


