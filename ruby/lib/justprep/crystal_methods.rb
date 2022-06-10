# common/crystal_methods.rb

# Monkey oatch Ruby classes to match method names
# used by Crystal

# TODO: find other classes in which Ruby/Crystal differ

class Array
  alias_method :includes?, :include?
end

class Pathname
  alias_method :exists?, :exist?
end

class String
  alias_method :starts_with?, :start_with?
end
