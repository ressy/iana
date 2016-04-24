# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iana/version'

Gem::Specification.new do |spec|
  spec.name          = "iana-data"
  spec.version       = Iana::VERSION
  spec.authors       = ["Runar Ingebrigtsen", "Ramsey Dow"]
  spec.email         = %w{runar@rin.no, yesmar@gmail.com}

  spec.summary       = %q{Look up official IANA data, replacement for iana gem}
  spec.homepage      = "http://github.com/ringe/iana"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'yard', '~> 0.8'

  spec.add_dependency "open-uri-cached", "= 0.0.5"
  spec.add_dependency "nokogiri", '~> 1.6'
end
