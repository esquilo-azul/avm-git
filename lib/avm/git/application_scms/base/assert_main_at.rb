# frozen_string_literal: true

module Avm
  module Git
    module ApplicationScms
      class Base < ::Avm::ApplicationScms::Base
        class AssertMainAt
          MAIN_REFERENCE = 'HEAD'

          acts_as_instance_method
          enable_simple_cache
          common_constructor :base, :path

          # @return [Pathname]
          def result
            local_repos.remote(base.git_https_url).fetch
            local_repos.command('checkout', remote_head_commit_id).execute!
            path
          end

          private

          # @return [String]
          def remote_head_commit_id
            remote_repos.ls.fetch(MAIN_REFERENCE)
          end

          # @return [EacGit::Local]
          def local_repos_uncached
            path.mkpath
            r = ::EacGit::Local.new(path)
            r.command('init').execute! unless r.root_path.join('.git').exist?
            r
          end

          # @return [EacGit::Remote]
          def remote_repos_uncached
            ::EacGit::Remote.new(base.git_https_url)
          end
        end
      end
    end
  end
end
