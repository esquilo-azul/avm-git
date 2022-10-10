# frozen_string_literal: true

require 'avm/launcher/errors/base'
require 'avm/launcher/stereotype'

module Avm
  module Git
    module Launcher
      module SubWarpBase
        private

        def parent_instance_uncached
          r = find_parent_instance(instance.parent)
          return r if r

          ::Avm::Launcher::Errors::Base.new('Git parent not found')
        end

        def find_parent_instance(current)
          if ::Avm::Launcher::Stereotype.git_stereotypes.any? { |s| current.stereotype?(s) }
            return current
          end

          current.parent ? find_parent_instance(current.parent) : nil
        end

        def to_parent_git_path
          instance.logical.gsub(%r{\A#{Regexp.quote(parent_instance.logical)}/}, '')
        end
      end
    end
  end
end
