# justprep/test/test.s
#
# Save the current system envar because the tests will change it

original_for=$JUSTPREP_FOR
original_filename_in=$JUSTPREP_FILENAME_IN
original_filename_out=$JUSTPREP_FILENAME_OUT


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

cp ./temp.${JUSTPREP_FOR} $HOME

source ./envar-test-cr.s
source ./envar-test-rb.s


echo
echo "########################"
echo "# testing fake modules #"
echo "########################"
echo

source ./module-test-cr.s
source ./module-test-rb.s


###################################################
## End of Tests Cleanup

rm -f ~/temp.${JUSTPREP_FOR}

# restore the original system envar ...
export JUSTPREP_FOR=$original_for
export JUSTPREP_FILENAME_IN=$original_filename_in
export JUSTPREP_FILENAME_OUT=$original_filename_out
