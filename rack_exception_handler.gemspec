# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack_exception_handler/version'

Gem::Specification.new do |spec|
  spec.name          = "rack_exception_handler"
  spec.version       = RackExceptionHandler::VERSION
  spec.authors       = ["Tatum Szymczak"]
  spec.email         = ["tatum@ashlandstudios.com"]

  spec.summary       = %q{ Handle an exception and present a form.}
  spec.description   = %q{Handle an exception and present a form.}
  spec.homepage      = "https://github.com/tatums/rack_exception_handler"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack", "~> 1.6"
  spec.add_runtime_dependency "mail"
  spec.add_runtime_dependency "slack-notifier"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec-html-matchers"
end
