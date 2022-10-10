# frozen_string_literal: true

require 'active_support/core_ext/object'

module Avm
  module Git
    module Launcher
      class Base < ::Avm::Launcher::Paths::Real
        module DirtyFiles
          delegate :dirty?, to: :eac_git

          def dirty_files
            eac_git.dirty_files.map do |df|
              ::OpenStruct.new(
                df.to_h.merge(path: df.path.to_path, absolute_path: df.absolute_path.to_path)
              )
            end
          end
        end
      end
    end
  end
end
