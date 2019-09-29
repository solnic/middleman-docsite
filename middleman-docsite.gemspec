# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'middleman/docsite/version'

Gem::Specification.new do |spec|
  spec.name = 'middleman-docsite'
  spec.version = Middleman::Docsite::VERSION
  spec.authors = ['Piotr Solnica']
  spec.email = ['piotr.solnica@gmail.com']

  spec.summary = 'Middleman extensions extracted from rom-rb and dry-rb websites'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/solnic/middleman-docsite'
  spec.license = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'lib/**/*']
  spec.require_paths = ['lib']
end
