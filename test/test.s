# justprep/test/test.s
#
# Save the current system envar because the tests will change it

original_filename_in=$JUSTPREP_FILENAME_IN

export JUSTPREP_FILENAME_IN=main.just


echo
echo "##########################"
echo "# testing the HAPPY path #"
echo "##########################"
echo

source ./test-cr.s
source ./test-rb.s


echo
echo "############################"
echo "# testing error conditions #"
echo "############################"
echo

source ./error-test-cr.s
source ./error-test-rb.s


echo
echo "######################################"
echo "# testing the ability to GLOB a path #"
echo "######################################"
echo

source ./glob-test-cr.s
source ./glob-test-rb.s


echo
echo "#########################"
echo "# testing use of envars #"
echo "#########################"
echo

cp ./temp.just $HOME

source ./envar-test-cr.s
source ./envar-test-rb.s

rm -f ~/temp.just

# restore the original system envar ...
export JUSTPREP_FILENAME_IN=$original_filename_in
