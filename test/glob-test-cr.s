# justprep/test/glob-test-cr.s

echo
echo "+---------+"
echo "| Crystal |"
echo "+---------+"
echo

echo "Testing the glob paths Crystal version..."

export JUSTPREP_FILENAME_IN=glob_good.just

rm -f justfile
../crystal/bin/justprep
echo "exit code: $?"
cat justfile glob_dir/expected_justfile

export JUSTPREP_FILENAME_IN=glob_bad.just

rm -f justfile
../crystal/bin/justprep
echo "exit code: $?"

echo "Done."
