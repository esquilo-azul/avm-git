# frozen_string_literal: true

module Avm
  module Git
    module LauncherStereotypes
      class Git
        require_sub __FILE__
        include Avm::Launcher::Stereotype

        class << self
          def match?(path)
            File.directory?(path.real.subpath('.git'))
          end

          def color
            :white
          end
        end
      end
    end
  end
end
