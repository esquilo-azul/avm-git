# frozen_string_literal: true

module Avm
  module Git
    module LauncherStereotypes
      class GitSubtree
        require_sub __FILE__
        include Avm::Launcher::Stereotype

        class << self
          def match?(path)
            return false if other_git_stereotype?(path)
            return false unless other_nogit_stereotype?(path)

            parent = parent_git(path.parent_path)
            return false unless parent

            ::Git.open(parent.real).remote(path.real.basename).url ? true : false
          end

          def color
            :green
          end

          def parent_git(parent_path)
            return nil unless parent_path

            if ::Avm::Git::LauncherStereotypes::Git.match?(parent_path)
              parent_path
            else
              parent_git(parent_path.parent_path)
            end
          end

          def other_git_stereotype?(path)
            ::Avm::Git::LauncherStereotypes::Git.match?(path) ||
              ::Avm::Git::LauncherStereotypes::GitSubrepo.match?(path)
          end

          def other_nogit_stereotype?(path)
            Avm::Launcher::Stereotype.nogit_stereotypes.any? { |s| s.match?(path) }
          end
        end
      end
    end
  end
end
