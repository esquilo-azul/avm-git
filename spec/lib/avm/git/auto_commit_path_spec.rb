# frozen_string_literal: true

require 'avm/git/auto_commit_path'

RSpec.describe ::Avm::Git::AutoCommitPath, git: true do
  let(:git) { stubbed_git_local_repo }

  describe '#class_name' do
    {
      'app/models/mynamespace/the_class.rb' => 'Mynamespace::TheClass',
      'lib/ruby/lib/cliutils/eac_redmine_base0/activity.rb' => 'Cliutils::EacRedmineBase0::Activity'
    }.each do |relative_path, expected_class_name|
      context "when path is \"#{relative_path}\"" do
        let(:path) { git.root_path.join(relative_path) }
        let(:instance) { described_class.new(git, path) }

        it { expect(instance.class_name).to eq(expected_class_name) }
      end
    end
  end
end
