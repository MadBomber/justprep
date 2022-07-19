# justprep/test/test-rb.s

echo
echo "+------+"
echo "| Ruby |"
echo "+------+"
echo

echo "Testing --no-brag path with Ruby version..."

../ruby/bin/justprep --no-brag && cat justfile

echo "Done."
