# frozen_string_literal: true

module Avm
  module Git
    module LauncherStereotypes
      class Git
        class Warp < ::Avm::Git::Launcher::WarpBase
          private

          def current_ref
            'HEAD'
          end

          def source_instance
            instance
          end

          def source_remote_name
            ::Avm::Git::LauncherStereotypes::Git::Publish::PUBLISH_GIT_REMOTE_NAME
          end
        end
      end
    end
  end
end
