# .../modules/aaa.just

# Module aaa
@_aaa:
  echo 'Module aaa'
  just --list

# Do something Magical
@xyzzy thing='lion':
  echo "Magic from aaa"
  echo "... watch me pull a {{thing}} out of my hat."
