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

  s.add_dependency 'avm', '~> 0.94', '>= 0.94.1'
  s.add_dependency 'avm-files', '~> 0.8', '>= 0.8.1'
  s.add_dependency 'eac_git', '~> 0.17'
  s.add_dependency 'eac_ruby_utils', '~> 0.127'
  s.add_dependency 'git', '~> 1.19', '>= 1.19.1'

  s.add_development_dependency 'avm-eac_ubuntu_base0', '~> 0.5', '>= 0.5.1'
  s.add_development_dependency 'avm-tools', '~> 0.162'
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.11', '>= 0.11.1'
end
