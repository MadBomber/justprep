# ruby/test/common_test.rb

# Testing the commond method used by both Ruby and
# Crystal implementations.  These are loading in Ruby
# as kernel-level methods.  Because that is the
# way that the Crystal implementation is designed.

require_relative "test_helper"

IMPLEMENTATION = "CrystalRuby"

# Repository Root - set by direnv in .envrc
RR = ENV["RR"]

class CommonTest < Minitest::Test
  def test_that_it_has_a_constants
    refute_nil VERSION
    refute_nil JUSTPREP_FILENAME_IN
    refute_nil JUSTPREP_FILENAME_OUT
    refute_nil JUSTPREP_KEYWORDS
    refute_nil JUSTPREP_MODULE_KEYWORD
  end


  def test_error_messages
    skip "need way to test in both crystal and ruby"

    # result    = method(:error_file_does_not_exist).source_location
    # expected  = [".../justprep/ruby/lib/justprep/common/error_messages.crb", 10]

    # assert result.is_a?(Array)
    # assert_equal result.size,2
    # assert result[0].to_s.ends_with?("common/error_messages.crb")
  end


  def test_expand_file_path
    home = ENV["HOME"]

    assert_equal expand_file_path("~/temp.just"),           "#{home}/temp.just"
    assert_equal expand_file_path("$HOME/temp.just"),       "#{home}/temp.just"
    assert_equal expand_file_path("   $HOME/temp.just  "),  "#{home}/temp.just"
  end


  # Not much to test, it returns if no parameters
  # or it exits with a code 1 if there are.  A good
  # parameter will do some.  A bad one will get and error.
  def test_handle_command_line_parameters
    skip "need way to test in both Crystal and Ruby"

    # result    = method(:handle_command_line_parameters).source_location
    # expected  =[".../justprep/ruby/lib/justprep/common/handle_command_line_parameters.crb", 10]

    # assert result.is_a?(Array)
    # assert_equal result.size, 2
    # assert result[0].to_s.ends_with?("common/handle_command_line_parameters.crb")
  end


  def test_just_find_it
    # SMELL:  This test _ASSUMES_ that the JUSTPREP_FILENAME_IN
    #         value is "main.just"

    assert_equal JUSTPREP_FILENAME_IN, "main.just"

    from_here = "#{RR}/test/glob_dir/one"
    expected  = "/test/main.just"
    result    = just_find_it(from_here)

    assert result.to_s.ends_with?(expected)
  end


  # makes use of the constant JUSTPREP_FILENAME_IN
  # which comes from an envar by the same name.  Cannot
  # do this test because of syntax error dynamic constant
  # assignment.... that"s why they are called constants.
  #
  def test_just_find_it_not_found
    skip "Trust me.  You will make bacon with this!"
  end


  def test_usage
    usage_text = usage
    assert usage_text.to_s.includes? "justprep"
    assert usage_text.to_s.includes? VERSION
    assert usage_text.to_s.includes? "Dewayne VanHoozer"
    assert usage_text.to_s.includes? "Casey Rodarmor"
    assert usage_text.to_s.includes? "Greg Lutostanski"
  end


  def test_generate_module_recipes
    module_names = ["my_mod"]

    expected  = "

# Module my_mod
@my_mod what='' args='':
  just -f {{module_my_mod}} {{what}} {{args}}

"

    results   = generate_module_recipes(module_names)

    assert_equal results, expected
  end


  def test_replacement_for_module_line
    source    = "module #{ENV['RR']}/ruby/test/my_mod/justfile"
    expected  = "module_my_mod := \"my_mod/justfile\""

    module_name, module_filename = replacement_for_module_line(999, source)

    module_filename.gsub!(__dir__ + '/', '')

    assert_equal module_name, "my_mod"
    assert_equal module_filename, expected
  end


  def test_include_content_from
    skip "sinple function but should still be tested"
  end
end
