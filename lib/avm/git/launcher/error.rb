# frozen_string_literal: true

require 'avm/launcher/errors/base'

module Avm
  module Git
    module Launcher
      class Error < ::Avm::Launcher::Errors::Base
        def initialize(git_instance, message)
          super("#{message} (Repository: #{git_instance})")
        end
      end
    end
  end
end
