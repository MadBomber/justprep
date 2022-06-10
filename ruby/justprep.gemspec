# frozen_string_literal: true

load "lib/justprep/common/constants.crb"

Gem::Specification.new do |spec|
  spec.name          = "justprep"
  spec.version       = VERSION
  spec.authors       = ["Dewayne VanHoozer"]
  spec.email         = ["dvanhoozer@gmail.com"]

  spec.summary       = "A pre-processor for the 'just' command line utility"
  spec.description   = <<~EOS
    allows a "justfile" to be auto-generated from a seperate source file
    that contains inclusionary keywords such as include, import, require
    and with.  These keywords are followed by a path to a file.  If the
    file exists, the contents of the file are inserted into the file
    at the position of the keyword command.  After all keywords have
    been process a new "justfile" is created which can then be used by
    the 'just' tool.
  EOS

  spec.homepage      = "http://github.com/MadBomber/justprep/tree/main/ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = ""

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir        = "bin"
  spec.executables   = ["justprep"]
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  end

  spec.add_development_dependency 'bump'
end
