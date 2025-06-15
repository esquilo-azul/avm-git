# frozen_string_literal: true

require 'eac_ruby_utils'
EacRubyUtils::RootModuleSetup.perform __FILE__

require 'avm'
require 'eac_cli'
require 'eac_config'
require 'eac_git'
require 'filesize'
require 'git'

module Avm
  module Git
  end
end
