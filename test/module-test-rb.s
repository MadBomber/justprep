# justprep/test/module-test-rb.s

echo
echo "+------+"
echo "| Ruby |"
echo "+------+"
echo

echo "Testing fake modules Ruby version..."

export JUSTPREP_FILENAME_IN=module_good.just

rm -f justfile

../ruby/bin/justprep
echo "exit code: $?"
cat justfile


export JUSTPREP_FILENAME_IN=module_bad.just
rm -f justfile

../ruby/bin/justprep
echo "exit code: $?"
cat justfile

echo "Done."
