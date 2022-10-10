# frozen_string_literal: true

module Avm
  module Git
    module Launcher
      class Base < ::Avm::Launcher::Paths::Real
        module ClassMethods
          # @return [Avm::Git::Launcher::Base]
          def by_root(search_base_path)
            new(find_root(search_base_path).to_path)
          end

          # Searches the root path for the Git repository which includes +search_base_path+.
          # @return [Pathname]
          def find_root(search_base_path)
            path = search_base_path.to_pathname.expand_path
            loop do
              return path if path.join('.git').exist?
              raise "\".git\" not found for \"#{search_base_path}\"" if path.parent.root?

              path = path.parent
            end
          end
        end
      end
    end
  end
end
