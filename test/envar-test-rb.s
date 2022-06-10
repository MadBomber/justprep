# justprep/test/envar-test-rb.s

echo
echo "+------+"
echo "| Ruby |"
echo "+------+"
echo

echo "Testing the envar paths Ruby version..."

export JUSTPREP_FILENAME_IN=envar.just

rm -f justfile
cp -f ./temp.just $HOME

../ruby/bin/justprep
echo "exit code: $?"

cat justfile

rm -f ~/temp.just

echo "Done."
