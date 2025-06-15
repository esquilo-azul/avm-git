# frozen_string_literal: true

module Avm
  module Git
    module Launcher
      class Base < ::Avm::Launcher::Paths::Real
        module DirtyFiles
          delegate :dirty?, to: :eac_git

          # @return [Array<Struct>]
          def dirty_files
            eac_git.dirty_files.map do |df|
              df.to_h.merge(path: df.path.to_path, absolute_path: df.absolute_path.to_path)
                .to_struct
            end
          end
        end
      end
    end
  end
end
