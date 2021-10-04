# frozen_string_literal: true

require 'avm/result'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    class SubrepoCheck
      module Remote
        private

        def fetch_uncached
          subrepo.command('clean').execute!
          subrepo.command('fetch').execute!
        end

        def check_remote_disabled?
          !check_remote?
        end

        def check_remote_disabled_result
          ::Avm::Result.neutral('Check remote disabled')
        end

        def local_descend_remote?
          local_id.present? && remote_id.present? && subrepo.local.descendant?(local_id, remote_id)
        end

        def local_descend_remote_result
          ::Avm::Result.pending(remote_result_value)
        end

        def local_id_uncached
          fetch
          subrepo.command('branch', '--force').execute!
          subrepo.local.rev_parse("subrepo/#{subrepo.subpath}")
        end

        def remote_descend_local?
          local_id.present? && remote_id.present? && subrepo.local.descendant?(remote_id, local_id)
        end

        def remote_descend_local_result
          ::Avm::Result.outdated(remote_result_value)
        end

        def remote_branches
          ['', 'refs/heads/', 'refs/tags/'].map { |prefix| "#{prefix}#{subrepo.remote_branch}" }
        end

        def remote_id_uncached
          ls_result = subrepo.remote.ls
          remote_branches.each do |b|
            return ls_result[b] if ls_result[b].present?
          end
          nil
        end

        def remote_result_uncached
          %w[check_remote_disabled same_ids local_descend_remote remote_descend_local]
            .each do |condition|
            return send("#{condition}_result") if send("#{condition}?")
          end

          ::Avm::Result.error(remote_result_value)
        end

        def remote_result_value
          local_s = local_id.presence || blank_text
          remote_s = remote_id.presence || blank_text

          if local_s == remote_s
            "[L/R=#{local_s}]"
          else
            "[L=#{local_s}, R=#{remote_s}]"
          end
        end

        def same_ids?
          local_id.present? && remote_id.present? && local_id == remote_id
        end

        def same_ids_result
          ::Avm::Result.success(remote_result_value)
        end
      end
    end
  end
end
