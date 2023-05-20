# frozen_string_literal: true

require 'avm/scms/commit'
require 'avm/git/scms/git/commit'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class GitSubBase < ::Avm::Scms::Base
        class Commit < ::Avm::Scms::Commit
          common_constructor :scm, :parent_commit

          delegate :deploy_to_env_path, :fixup?, :id, :merge_with, :reword, :scm_file?, :subject,
                   :to_s, to: :parent_commit

          # @return [Array<Pathname>]
          def changed_files
            parent_commit.changed_files.map do |cf|
              cf.relative_path_from(scm.relative_path_from_parent_scm)
            end
          end
        end
      end
    end
  end
end
