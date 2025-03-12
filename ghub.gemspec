# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "ghub"
  spec.version = "0.23.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/ghub"
  spec.summary = "A monadic GitHub API client."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/ghub/issues",
    "changelog_uri" => "https://alchemists.io/projects/ghub/versions",
    "homepage_uri" => "https://alchemists.io/projects/ghub",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Ghub",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/ghub"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.4"
  spec.add_dependency "containable", "~> 1.1"
  spec.add_dependency "dry-monads", "~> 1.8"
  spec.add_dependency "dry-schema", "~> 1.13"
  spec.add_dependency "http", "~> 5.2"
  spec.add_dependency "infusible", "~> 4.0"
  spec.add_dependency "pipeable", "~> 1.1"
  spec.add_dependency "refinements", "~> 13.0"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
