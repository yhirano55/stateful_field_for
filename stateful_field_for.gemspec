$LOAD_PATH.push File.expand_path("lib", __dir__)

require "stateful_field_for/version"

Gem::Specification.new do |s|
  s.name        = "stateful_field_for"
  s.version     = StatefulFieldFor::VERSION
  s.authors     = ["Yoshiyuki Hirano"]
  s.email       = ["yhirano@me.com"]
  s.homepage    = "https://github.com/yhirano55/stateful_field_for"
  s.summary     = "Provide the bang and predicate methods for Active Record"
  s.description = s.summary
  s.license     = "MIT"

  s.required_ruby_version = ">= 2.2.0"

  s.add_dependency "railties", ">= 5.0"

  s.add_development_dependency "bundler", "~> 1.15"

  s.files      = Dir["{app,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]
end
