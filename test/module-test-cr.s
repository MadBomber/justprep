# justprep/test/module-test-cr.s

echo
echo "+---------+"
echo "| Crystal |"
echo "+---------+"
echo

echo "Testing fake modules Crystal version..."

export JUSTPREP_FILENAME_IN=module_good.$JUSTPREP_FOR

rm -f $JUSTPREP_FILENAME_OUT

../crystal/bin/justprep
echo "exit code: $?"

cat $JUSTPREP_FILENAME_OUT

export JUSTPREP_FILENAME_IN=module_bad.$JUSTPREP_FOR

rm -f $JUSTPREP_FILENAME_OUT


../crystal/bin/justprep
echo "exit code: $?"

echo "Done."
