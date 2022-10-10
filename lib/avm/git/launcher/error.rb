# frozen_string_literal: true

module Avm
  module Git
    module Launcher
      class Error < StandardError
        def initialize(git_instance, message)
          super("#{message} (Repository: #{git_instance})")
        end
      end
    end
  end
end
