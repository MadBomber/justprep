# frozen_string_literal: true

require "test_helper"

class JustprepTest < Minitest::Test
  def setup
    @jp = Justprep.new
  end

  def test_that_it_has_a_version_number
    refute_nil VERSION
  end

  def test_it_does_something_useful
    assert true
  end
end
