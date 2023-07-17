# frozen_string_literal: true

require_relative "lib/net/imap/multiappend/version"

Gem::Specification.new do |spec|
  spec.name = "net-imap-multiappend"
  spec.version = Net::Imap::Multiappend::VERSION
  spec.authors = ["Joe Yates"]
  spec.email = ["joe.g.yates@gmail.com"]

  spec.summary = "Add IMAP MULTIAPPEND functionality to the net-imap gem"
  spec.homepage = "https://github.com/joeyates/net-imap-multiappend"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/joeyates/net-imap-multiappend/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "net-imap", ">= 0.3.2"
end
