# justprep/test/envar-test-rb.s

echo
echo "+------+"
echo "| Ruby |"
echo "+------+"
echo

echo "Testing the envar paths Ruby version..."

export JUSTPREP_FILENAME_IN=envar.$JUSTPREP_FOR

rm -f $JUSTPREP_FILENAME_OUT

cp -f ./temp.$JUSTPREP_FOR $HOME

../ruby/bin/justprep
echo "exit code: $?"

cat $JUSTPREP_FILENAME_OUT

rm -f ~/temp.$JUSTPREP_FOR

echo "Done."
