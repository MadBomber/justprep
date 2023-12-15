# frozen_string_literal: true

load "lib/justprep/common/constants.crb"

Gem::Specification.new do |spec|
  spec.name          = "justprep"
  spec.version       = VERSION
  spec.authors       = ["Dewayne VanHoozer"]
  spec.email         = ["dvanhoozer@gmail.com"]

  spec.summary       = "Just a pre-processor for CLI task runners like 'just'"
  spec.description   = <<~EOS
    justprep is a CLI tool implemented as a Ruby gem AND a 
    compiled Crystal binary.  It allows a task file to be 
    auto-generated from seperate source files that contain 
    inclusionary keywords such as include, import, require 
    and with.
  EOS

  spec.homepage      = "http://github.com/MadBomber/justprep"
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
    spec.metadata['allowed_push_host'] = ENV['PUSH_HOST']
  end

  spec.add_development_dependency 'bump'
  spec.add_development_dependency 'debug_me'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'semver2'
end
