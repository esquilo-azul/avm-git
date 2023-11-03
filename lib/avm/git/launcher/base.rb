# frozen_string_literal: true

require 'eac_git/local'
require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/envs'
require 'avm/launcher/paths/real'
require 'avm/git/launcher/error'

module Avm
  module Git
    module Launcher
      class Base < ::Avm::Launcher::Paths::Real
        require_sub __FILE__
        enable_simple_cache
        extend ::Avm::Git::Launcher::Base::ClassMethods
        include ::Avm::Git::Launcher::Base::DirtyFiles
        include ::Avm::Git::Launcher::Base::Remotes
        include ::Avm::Git::Launcher::Base::Subrepo
        include ::Avm::Git::Launcher::Base::Underlying

        attr_reader :eac_git

        delegate :descendant?, :merge_base, :rev_parse, to: :eac_git

        def initialize(path)
          super(path)

          @eac_git = ::EacGit::Local.new(path)
        end

        def init_bare
          FileUtils.mkdir_p(self)
          ::EacRubyUtils::Envs.local.command('git', 'init', '--bare', self).execute! unless
          File.exist?(subpath('.git'))
        end

        # @return [Pathname]
        def root_path
          @root_path ||= self.class.find_root(to_s)
        end

        def descendant?(descendant, ancestor)
          base = merge_base(descendant, ancestor)
          return false if base.blank?

          revparse = execute!('rev-parse', '--verify', ancestor).strip
          base == revparse
        end

        def subtree_split(prefix)
          execute!('subtree', '-q', 'split', '-P', prefix).strip
        end

        def push(remote_name, refspecs, options = {})
          refspecs = [refspecs] unless refspecs.is_a?(Array)
          args = ['push']
          args << '--dry-run' if options[:dryrun]
          args << '--force' if options[:force]
          system!(args + [remote_name] + refspecs)
        end

        def push_all(remote_name)
          system!('push', '--all', remote_name)
          system!('push', '--tags', remote_name)
        end

        def fetch(remote_name, options = {})
          args = ['fetch', '-p', remote_name]
          args += %w[--tags --prune-tags --force] if options[:tags]
          execute!(*args)
        end

        def current_branch
          execute!(%w[symbolic-ref -q HEAD]).gsub(%r{\Arefs/heads/}, '').strip
        end

        def reset_hard(ref)
          execute!('reset', '--hard', ref)
        end

        def raise(message)
          ::Kernel.raise Avm::Git::Launcher::Error.new(self, message)
        end
      end
    end
  end
end
