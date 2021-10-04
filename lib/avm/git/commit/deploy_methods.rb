# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    class Commit
      module DeployMethods
        def deploy_to_env_path(target_env, target_path)
          Deploy.new(self, target_env, target_path)
        end

        def deploy_to_url(target_url)
          Deploy.new(self, *self.class.target_url_to_env_path(target_url))
        end
      end
    end
  end
end
