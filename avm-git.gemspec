# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'avm/git/version'

Gem::Specification.new do |s|
  s.name        = 'avm-git'
  s.version     = Avm::Git::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{lib,locale}/**/*']
  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'avm', '~> 0.82'
  s.add_dependency 'avm-files', '~> 0.6', '>= 0.6.2'
  s.add_dependency 'eac_git', '~> 0.14', '>= 0.14.1'
  s.add_dependency 'eac_ruby_utils', '~> 0.119', '>= 0.119.2'
  s.add_dependency 'git', '~> 1.18'

  s.add_development_dependency 'aranha-parsers', '~> 0.8', '>= 0.8.5'
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.7.0'
end
