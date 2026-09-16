# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'avm/git/version'

Gem::Specification.new do |s|
  s.name        = 'avm-git'
  s.version     = Avm::Git::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{lib,locale}/**/*']
  s.required_ruby_version = '>= 2.7' # rubocop:disable Gemspec/RequiredRubyVersion

  s.add_dependency 'avm', '~> 0.103'
  s.add_dependency 'eac_git', '~> 0.22'
  s.add_dependency 'eac_ruby_utils', '~> 0.134'
  s.add_dependency 'filesize', '~> 0.2'
  s.add_dependency 'git', '~> 1.19', '>= 1.19.1'

  s.add_development_dependency 'avm-eac_ubuntu_base0', '~> 0.7', '>= 0.7.2'
  s.add_development_dependency 'avm-tools', '~> 0.164', '>= 0.164.1'
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.15'
end
