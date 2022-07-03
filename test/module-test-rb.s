# justprep/test/module-test-rb.s

echo
echo "+------+"
echo "| Ruby |"
echo "+------+"
echo

echo "Testing fake modules Ruby version..."

export JUSTPREP_FILENAME_IN=module_good.$JUSTPREP_FOR

rm -f $JUSTPREP_FILENAME_OUT

../ruby/bin/justprep
echo "exit code: $?"

cat $JUSTPREP_FILENAME_OUT


export JUSTPREP_FILENAME_IN=module_bad.$JUSTPREP_FOR

rm -f $JUSTPREP_FILENAME_OUT

../ruby/bin/justprep
echo "exit code: $?"

cat $JUSTPREP_FILENAME_OUT

echo "Done."
