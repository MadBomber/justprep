# justprep/test/envar-test-cr.s

echo
echo "+---------+"
echo "| Crystal |"
echo "+---------+"
echo

echo "Testing the envar paths Crystal version..."

export JUSTPREP_FILENAME_IN=envar.just

rm -f justfile
cp -f ./temp.just $HOME

../crystal/bin/justprep
echo "exit code: $?"

cat justfile

rm -f ~/temp.just

echo "Done."
