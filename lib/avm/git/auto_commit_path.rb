# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    class AutoCommitPath
      require_sub __FILE__, include_modules: true
      common_constructor :git, :path do
        self.path = path.to_pathname
      end

      def class_name
        ruby_class_name || relative_path.to_path
      end

      def commit_message
        r = class_name
        r += ': remove' unless path.file?
        r + '.'
      end

      def relative_path
        path.expand_path.relative_path_from(git.root_path.expand_path)
      end
    end
  end
end
