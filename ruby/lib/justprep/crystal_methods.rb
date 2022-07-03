# common/crystal_methods.rb

# Monkey oatch Ruby classes to match method names
# used by Crystal

# TODO: find other classes in which Ruby/Crystal differ

module Enumerable
  alias_method :includes?, :include?
end

class Pathname
  alias_method :exists?, :exist?
end

class String
  alias_method :starts_with?, :start_with?
  alias_method :ends_with?,   :end_with?
  alias_method :includes?,    :include?
end

class File
  class << self
    alias_method :read_lines, :readlines
  end
end
