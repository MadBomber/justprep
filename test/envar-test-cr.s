# justprep/test/envar-test-cr.s

echo
echo "+---------+"
echo "| Crystal |"
echo "+---------+"
echo

echo "Testing the envar paths Crystal version..."

export JUSTPREP_FILENAME_IN=envar.$JUSTPREP_FOR

rm -f $JUSTPREP_FILENAME_OUT

cp -f ./temp.$JUSTPREP_FOR $HOME

../crystal/bin/justprep
echo "exit code: $?"

cat $JUSTPREP_FILENAME_OUT

rm -f ~/temp.$JUSTPREP_FOR

echo "Done."
