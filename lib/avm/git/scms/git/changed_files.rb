# frozen_string_literal: true

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
              ::Avm::Git::Scms::Git::ChangedFile.new(scm, dirty_file)
            end
          end
        end
      end
    end
  end
end
