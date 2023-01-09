# frozen_string_literal: true

require 'avm/git/scms/git/changed_file'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class ChangedFiles
          enable_method_class
          common_constructor :scm

          # @return [Avm::Git::Scms::Git::ChangedFile]
          def result
            scm.git_repo.dirty_files.map do |dirty_file|
              ::Avm::Git::Scms::Git::ChangedFile.new(scm, dirty_file.path)
            end
          end
        end
      end
    end
  end
end
