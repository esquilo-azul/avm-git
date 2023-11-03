# frozen_string_literal: true

require 'avm/git/launcher/mirror_update'
require 'avm/launcher/instances/error'
require 'avm/git/vendor/github'
require 'avm/git/launcher_stereotypes/git/publish'

module Avm
  module Git
    module Launcher
      # Métodos abstratos:
      #  * source_instance
      #  * source_remote_name
      #  * current_ref
      class WarpBase < ::Avm::Launcher::Paths::Real
        include ::EacRubyUtils::SimpleCache

        TARGET_REMOTE = ::Avm::Git::LauncherStereotypes::Git::Publish::PUBLISH_GIT_REMOTE_NAME

        def initialize(instance)
          @instance = instance
          cache_git.git.reset_hard(current_ref)
          cache_git.remote(TARGET_REMOTE).url = target_remote_url
          super(path)
        end

        protected

        attr_reader :instance

        def validate_source_current_revision
          if source_git.rev_parse(source_instance.options.git_current_revision, false).present?
            return
          end

          raise ::Avm::Launcher::Instances::Error,
                "Refspec \"#{source_instance.options.git_current_revision}\" " \
                "not found in \"#{source_git}\""
        end

        def update
          validate_source_current_revision
          ::Avm::Git::Launcher::MirrorUpdate.new(
            path,
            source_instance.real,
            source_instance.options.git_current_revision
          )
        end

        def path
          instance.cache_path('git_repository')
        end

        def source_git_uncached
          ::Avm::Git::Launcher::Base.new(source_instance.real)
        end

        def cache_git_uncached
          ::Avm::Git::Launcher::Base.new(update)
        end

        def target_remote_url
          ::Avm::Git::Vendor::Github.to_ssh_url(source_git.git.remote(source_remote_name).url)
        end
      end
    end
  end
end
