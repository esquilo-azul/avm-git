# frozen_string_literal: true

require 'avm/scms/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class GitSubBase < ::Avm::Scms::Base
        enable_abstract_methods

        delegate :changed_files, :commit_if_change, :current_milestone_base_commit, :interval,
                 :head_commit, :reset_and_commit, :run_commit, to: :parent_scm
      end
    end
  end
end
