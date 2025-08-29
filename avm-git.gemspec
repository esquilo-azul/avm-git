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

  s.add_dependency 'avm', '~> 0.98'
  s.add_dependency 'avm-files', '~> 0.9'
  s.add_dependency 'eac_git', '~> 0.18', '>= 0.18.1'
  s.add_dependency 'eac_ruby_utils', '~> 0.128', '>= 0.128.3'
  s.add_dependency 'git', '~> 1.19', '>= 1.19.1'

  s.add_development_dependency 'avm-eac_ubuntu_base0', '~> 0.6'
  s.add_development_dependency 'avm-tools', '~> 0.163', '>= 0.163.3'
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.12'
end
