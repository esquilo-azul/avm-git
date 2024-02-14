# frozen_string_literal: true

require 'avm/git/launcher_stereotypes/git_subrepo/warp'

RSpec.describe Avm::Git::LauncherStereotypes::GitSubrepo::Warp do
  let(:repos) { init_remote('mylib_repos') }
  let(:app1) { init_git('app1') } # rubocop:disable RSpec/IndexedLet
  let(:app2) { init_git('app2') } # rubocop:disable RSpec/IndexedLet

  describe '#unknown' do
    before do
      temp_context(File.join(__dir__, 'warp_spec_settings.yml'))

      wc = init_git('mylib_wc')
      touch_commit(wc, 'file1')
      wc.execute!('remote', 'add', 'origin', repos)
      wc.execute!('push', 'origin', 'master')

      touch_commit(app1, 'file2')
      app1.execute!('subrepo', 'clone', repos, 'mylib')

      touch_commit(app2, 'file3')
      app2.execute!('subrepo', 'clone', repos, 'mylib')
      touch_commit(app2, 'mylib/file4')
      app2.execute!('subrepo', 'push', 'mylib')
    end

    it 'revisions should match' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      master_ref = repos.rev_parse('master')
      expect(master_ref.present?).to be true

      master_ref_previous = repos.rev_parse('master^')
      expect(master_ref_previous.present?).to be true

      app2.execute!('subrepo', 'branch', 'mylib', '--fetch', '--force')
      expect(app2.rev_parse('subrepo/mylib')).to eq master_ref

      app1.execute!('subrepo', 'branch', 'mylib', '--fetch', '--force')
      expect(app1.rev_parse('subrepo/mylib')).to eq master_ref_previous

      instance = Avm::Launcher::Context.current.instance('/app1/mylib')
      expect(instance).to be_a Avm::Launcher::Instances::Base
      warp = instance.warped
      expect(warp).to be_a described_class
      wgit = Avm::Git::Launcher::Base.new(warp)
      expect(wgit.rev_parse('HEAD')).to eq master_ref_previous
    end
  end
end
