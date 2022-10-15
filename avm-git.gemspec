# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'avm/git/version'

Gem::Specification.new do |s|
  s.name        = 'avm-git'
  s.version     = Avm::Git::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{lib}/**/*']

  s.add_dependency 'avm', '~> 0.50'
  s.add_dependency 'avm-files', '~> 0.4', '>= 0.4.1'
  s.add_dependency 'eac_git', '~> 0.13'
  s.add_dependency 'eac_ruby_utils', '~> 0.104'
  s.add_dependency 'git', '~> 1.12'

  s.add_development_dependency 'aranha-parsers', '~> 0.8', '>= 0.8.5'
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.4'
end
