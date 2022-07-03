# justprep/test/error-test-rb.s

echo
echo "+------+"
echo "| Ruby |"
echo "+------+"
echo

echo "Testing the error paths Ruby version..."

export JUSTPREP_FILENAME_IN=error_bad.$JUSTPREP_FOR

rm -f $JUSTPREP_FILENAME_OUT

../ruby/bin/justprep
echo "exit code: $?"

export JUSTPREP_FILENAME_IN=error_missing.$JUSTPREP_FOR

rm -f $JUSTPREP_FILENAME_OUT

../ruby/bin/justprep
echo "exit code: $?"

echo "Done."
