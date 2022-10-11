# frozen_string_literal: true

require 'avm/git/launcher/warp_base'
require 'avm/git/launcher/sub_warp_base'

module Avm
  module Git
    module LauncherStereotypes
      class GitSubtree
        class Warp < ::Avm::Git::Launcher::WarpBase
          include ::Avm::Git::Launcher::SubWarpBase

          private

          def current_ref
            instance.cache_key("git_subtree.parent.#{cache_git.git.object('HEAD').sha}") do
              cache_git.subtree_split(to_parent_git_path)
            end
          end

          def source_instance
            parent_instance
          end

          def source_remote_name
            instance.project_name
          end
        end
      end
    end
  end
end
