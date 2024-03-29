# frozen_string_literal: true

require_relative "test_helper"

class ModuleTest < Minitest::Test
  def setup
    @jp = Justprep.new
  end


  def test_module_keyword
    assert_equal @jp.justprep_module_keyword, 'module'
  end


  def test_module_names_array
    assert @jp.module_names.is_a?(Array)
    assert_equal @jp.module_names.size, 0
  end
end
