# ruby/test/common_test.rb

=begin
  Testing the commond method used by both Ruby and
  Crystal implementations.  These are loading in Ruby
  as kernel-level methods.  Because that is the
  way that the Crystal implementation is designed.
=end

require 'test_helper'

class CommonTest < Minitest::Test
  def test_that_it_has_a_constants
    refute_nil VERSION
    refute_nil JUSTPREP_FILENAME_IN
    refute_nil JUSTPREP_FILENAME_OUT
    refute_nil JUSTPREP_KEYWORDS
  end


  def test_error_messages
    result    = method(:error_file_does_not_exist).source_location
    expected  = [".../justprep/ruby/lib/justprep/common/error_messages.crb", 10]

    assert result.is_a?(Array)
    assert_equal result.size,2
    assert result[0].end_with?("common/error_messages.crb")
  end


  def test_expand_file_path
    home = ENV['HOME']

    assert_equal expand_file_path('~/temp.just'),           "#{home}/temp.just"
    assert_equal expand_file_path('$HOME/temp.just'),       "#{home}/temp.just"
    assert_equal expand_file_path('   $HOME/temp.just  '),  "#{home}/temp.just"
  end


  # Not much to test, it returns if no parameters
  # or it exits with a code 1 if there are.  A good
  # parameter will do some.  A bad one will get and error.
  def test_handle_command_line_parameters
    result    = method(:handle_command_line_parameters).source_location
    expected  =[".../justprep/ruby/lib/justprep/common/handle_command_line_parameters.crb", 10]

    assert result.is_a?(Array)
    assert_equal result.size, 2
    assert result[0].end_with?("common/handle_command_line_parameters.crb")
  end


  def test_just_find_it
    # SMELL:  This test _ASSUMES_ that the JUSTPREP_FILENAME_IN
    #         value is 'main.just'

    assert_equal JUSTPREP_FILENAME_IN, 'main.just'

    from_here = Pathname.pwd + '../test/glob_dir/one'
    expected  = "/test/main.just"
    result    = just_find_it(from_here)

    assert result.end_with?(expected)
  end


  # makes use of the constant JUSTPREP_FILENAME_IN
  # which comes from an envar by the same name.  Cannot
  # do this test because of syntax error dynamic constant
  # assignment.... that's why they are called constants.
  #
  def test_just_find_it_not_found
    skip "Trust me.  You will make bacon with this!"
  end


  def test_usage
    usage_text = usage
    assert usage_text.include? 'justprep'
    assert usage_text.include? VERSION
    assert usage_text.include? 'Dewayne VanHoozer'
    assert usage_text.include? 'Casey Rodarmor'
    assert usage_text.include? 'Greg Lutostanski'
  end
end
