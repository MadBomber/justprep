# justprep/test/test-cr.s

echo
echo "+---------+"
echo "| Crystal |"
echo "+---------+"
echo

echo "Testing the --no-brag path with Crystal version..."

../crystal/bin/justprep --no-brag && cat justfile

echo "Done."
