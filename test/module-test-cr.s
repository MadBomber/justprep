# justprep/test/module-test-cr.s

echo
echo "+---------+"
echo "| Crystal |"
echo "+---------+"
echo

echo "Testing fake modules Crystal version..."

export JUSTPREP_FILENAME_IN=module_good.just

rm -f justfile
../crystal/bin/justprep
echo "exit code: $?"
cat justfile

export JUSTPREP_FILENAME_IN=module_bad.just

rm -f justfile
../crystal/bin/justprep
echo "exit code: $?"

echo "Done."
