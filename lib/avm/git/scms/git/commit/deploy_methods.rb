# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class Commit < ::Avm::Scms::Commit
          module DeployMethods
            def deploy_to_env_path(target_env, target_path)
              ::Avm::Git::Scms::Git::Commit::Deploy.new(self, target_env, target_path)
            end

            def deploy_to_url(target_url)
              ::Avm::Git::Scms::Git::Commit::Deploy.new(
                self,
                *::Avm::Git::Commit.target_url_to_env_path(target_url)
              )
            end
          end
        end
      end
    end
  end
end
