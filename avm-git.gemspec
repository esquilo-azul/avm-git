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

  s.add_dependency 'avm', '~> 0.86'
  s.add_dependency 'avm-files', '~> 0.7'
  s.add_dependency 'eac_git', '~> 0.16'
  s.add_dependency 'eac_ruby_utils', '~> 0.121'
  s.add_dependency 'git', '~> 1.19', '>= 1.19.1'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.9'
end
