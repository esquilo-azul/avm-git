# frozen_string_literal: true

module Avm
  module Git
    module LauncherStereotypes
      class Git
        class Publish < ::Avm::Git::Launcher::PublishBase
          PUBLISH_GIT_REMOTE_NAME = 'publish'
        end
      end
    end
  end
end
