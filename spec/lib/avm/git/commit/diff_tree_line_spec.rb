# frozen_string_literal: true

require 'avm/git/commit/diff_tree_line'

RSpec.describe ::Avm::Git::Commit::DiffTreeLine, git: true do
  include_examples 'source_target_fixtures', __FILE__ do
    def source_data(source_file)
      ::File.read(source_file).each_line.map do |line|
        described_class.new(line).fields
      end
    end
  end
end
