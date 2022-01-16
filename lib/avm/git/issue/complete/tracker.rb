# frozen_string_literal: true

require 'clipboard'

module Avm
  module Git
    module Issue
      class Complete
        module Tracker
          def clipboard_copy_tracker_message
            ::Clipboard.copy(textile_tracker_message)
            infov 'Copied to clipboard', textile_tracker_message
          end

          private

          def textile_tracker_message_uncached
            "Revisado para commit:#{branch_short_hash}, ok."
          end

          def branch_short_hash
            git_execute(['log', '--pretty=format:%h', '-1', '-q', branch_hash])
          end
        end
      end
    end
  end
end
