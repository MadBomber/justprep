# justprep/test/glob-test-rb.s

echo
echo "+------+"
echo "| Ruby |"
echo "+------+"
echo

echo "Testing the glob paths Ruby version..."

export JUSTPREP_FILENAME_IN=glob_good.just

rm -f justfile

../ruby/bin/justprep
echo "exit code: $?"
cat justfile


export JUSTPREP_FILENAME_IN=glob_bad.just
rm -f justfile

../ruby/bin/justprep
echo "exit code: $?"
cat justfile

echo "Done."
