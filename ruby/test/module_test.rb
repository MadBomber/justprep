# frozen_string_literal: true

require_relative "test_helper"

class ModuleTest < Minitest::Test
  def setup
    @jp = Justprep.new
  end


  def test_module_keyword
    assert_equal JUSTPREP_MODULE_KEYWORD, 'module'
  end


  def test_module_names_array
    assert @jp.module_names.is_a?(Array)
    assert_equal @jp.module_names.size, 0
  end

  def test_replacement_for_module_line
    source    = "module #{ENV['RR']}/ruby/test/my_mod/justfile"
    expected  = "module_my_mod := \"my_mod/justfile\""
    results   = @jp.replacement_for_module_line(999, source).gsub(__dir__ + '/', '')

    assert_equal @jp.module_names, ['my_mod']
    assert_equal results, expected
  end


end
