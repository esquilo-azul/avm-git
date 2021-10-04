# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Organize
      class Repository
        enable_simple_cache
        common_constructor :eac_git_local

        def collected_references
          @collected_references || []
        end

        def collect_subrepos
          collect_references_with_pattern(
            %r{\Asubrepo/},
            ::Avm::Git::Organize::ReferenceUpdate::OPERATION_REMOVE
          )
          collect_references_with_pattern(
            %r{\Aheads/subrepo/},
            ::Avm::Git::Organize::ReferenceUpdate::OPERATION_REMOVE
          )
        end

        def collect_originals
          collect_references_with_pattern(
            %r{\Aoriginal/},
            ::Avm::Git::Organize::ReferenceUpdate::OPERATION_REMOVE
          )
        end

        def all_branches
          eac_git_local.execute!
        end

        delegate :to_s, to: :eac_git_local

        private

        def all_references
          ::Pathname.glob("#{refs_root}/**/*").select(&:file?)
                    .map { |p| p.relative_path_from(refs_root).to_path }
        end

        def reference_update_by_ref(reference)
          collected_references.find { |ru| ru.reference == reference }
        end

        def collect_reference(reference, operation)
          new_ru = ::Avm::Git::Organize::ReferenceUpdate.new(self, reference, operation)
          reference_update_by_ref(new_ru.reference).if_present do |ru_found|
            raise "Reference #{new_ru} already added (#{ru_found})"
          end
          @collected_references ||= []
          @collected_references << new_ru
        end

        def collect_references_with_pattern(pattern, operation)
          references_with_pattern(pattern).each do |reference|
            collect_reference(reference, operation)
          end
        end

        def references_with_pattern(pattern)
          all_references.select { |reference| pattern.if_match(reference, false) }
        end

        def refs_root_uncached
          eac_git_local.root_path / '.git' / 'refs'
        end
      end
    end
  end
end
