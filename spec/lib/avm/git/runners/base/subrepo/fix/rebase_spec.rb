# frozen_string_literal: true

RSpec.describe Avm::Git::Runners::Base::Subrepo::Fix::Rebase, :git do
  let(:git) { stubbed_git_local_repo }
  let!(:root_commit) { git.random_commit.id }
  let!(:first_commit) { git.random_commit.id }
  let!(:second_commit) { git.random_commit.id }
  let(:exec_command) { 'touch exec.txt && git add exec.txt && git commit --amend --no-edit' }
  let(:instance) { described_class.new(git, root_commit, first_commit => exec_command) }

  describe '#todo' do
    it do
      expect(instance.todo).to eq("pick #{first_commit}\nexec #{exec_command}\n" \
                                  "pick #{second_commit}\n")
    end
  end

  describe '#perform' do
    before { instance.perform }

    it do
      expect(git.command('show', '--name-only', '--format=', 'HEAD~1').execute!.split)
        .to include('exec.txt')
    end

    it { expect(git.rev_parse('HEAD~2')).to eq(root_commit) }
  end
end
