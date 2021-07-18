# justprep/test/error-test-rb.s

echo "Testing the error paths Ruby version..."

export JUSTPREP_FILENAME_IN=error_bad.just

rm -f justfile
../ruby/bin/justprep
echo "exit code: $?"

export JUSTPREP_FILENAME_IN=error_missing.just

rm -f justfile
../ruby/bin/justprep
echo "exit code: $?"

echo "Done."
