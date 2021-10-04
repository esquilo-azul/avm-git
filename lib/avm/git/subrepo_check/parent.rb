# frozen_string_literal: true

require 'avm/result'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    class SubrepoCheck
      module Parent
        def fix_parent
          return if parent_result.success?

          info('  Fixing...')
          self.parent_hash = expected_parent_hash
          info_banner
        end

        private

        def expected_parent_hash_uncached
          subrepo.local.rev_parse("#{last_file_change_rev}^")
        end

        def last_file_change_rev
          subrepo.local.command('log', '-n', '1', '--pretty=format:%H', '--',
                                subrepo.config_relative_path.to_path).execute!.strip
        end

        def parent_hash
          subrepo.parent_commit_id
        end

        def parent_hash=(new_hash)
          subrepo.config.parent_commit_id = new_hash
          subrepo.write_config
        end

        def parent_hash_ok?
          return false if expected_parent_hash.blank? || parent_hash.blank?

          expected_parent_hash == parent_hash
        end

        def parent_result_uncached
          ::Avm::Result.success_or_error(parent_hash_ok?,
                                         parent_hash.presence || blank_text)
        end
      end
    end
  end
end
