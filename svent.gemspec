# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'svent/version'

Gem::Specification.new do |spec|
  spec.name          = "svent"
  spec.version       = Svent::VERSION
  spec.authors       = ["molingyu"]
  spec.email         = ["z1422716486@hotmail.com"]

  spec.summary       = %q{an async event framework}
  spec.description   = %q{Svent is an async event framework implemented with Fiber.Used for game or GUI event handling. }
  spec.homepage      = "https://github.com/molingyu/svent"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://github.com/molingyu/svent"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
