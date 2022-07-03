# justprep/test/error-test-cr.s

echo
echo "+---------+"
echo "| Crystal |"
echo "+---------+"
echo

echo "Testing the error paths Crystal version..."

export JUSTPREP_FILENAME_IN=error_bad.$JUSTPREP_FOR

rm -f $JUSTPREP_FILENAME_OUT

../crystal/bin/justprep
echo "exit code: $?"

export JUSTPREP_FILENAME_IN=error_missing.$JUSTPREP_FOR

rm -f $JUSTPREP_FILENAME_OUT

../crystal/bin/justprep
echo "exit code: $?"

echo "Done."
