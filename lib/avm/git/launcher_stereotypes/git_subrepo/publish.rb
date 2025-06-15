# frozen_string_literal: true

module Avm
  module Git
    module LauncherStereotypes
      class GitSubrepo
        class Publish < ::Avm::Git::Launcher::PublishBase
          # @return [Pathname]
          def config_path
            instance.parent.warped.to_pathname.join(
              "./#{instance.to_parent_path}",
              ::Avm::Git::LauncherStereotypes::GitSubrepo::CONFIG_SUBPATH
            )
          end

          # @return [EacGit::Local::Subrepo::Config]
          def config
            ::EacGit::Local::Subrepo::Config.from_file(config_path)
          end

          # @return [String]
          def remote_ref
            config.remote_branch || super
          end
        end
      end
    end
  end
end
