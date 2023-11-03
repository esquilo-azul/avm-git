# frozen_string_literal: true

require 'avm/git/launcher/base'

RSpec.describe ::Avm::Git::Launcher::Base do
  context 'new non-bare repository' do # rubocop:disable RSpec/ContextWording
    let(:repo) do
      r = described_class.new(::Dir.mktmpdir)
      r.git
      r
    end

    describe '#remote_exist?' do
      it { expect(repo.remote_exist?('origin')).to be(false) }

      context 'after remote added' do # rubocop:disable RSpec/ContextWording, :
        before { repo.execute!('remote', 'add', 'origin', 'file:///path/to/remote') }

        it { expect(repo.remote_exist?('origin')).to be(true) }

        context 'after remote removed' do # rubocop:disable RSpec/ContextWording, :
          before { repo.execute!('remote', 'remove', 'origin') }

          it { expect(repo.remote_exist?('origin')).to be(false) }
        end
      end
    end

    describe '#assert_remote_url' do
      it { expect(repo.remote_exist?('origin')).to be(false) }

      context 'after asserted remote URL "/remote1"' do # rubocop:disable RSpec/ContextWording, :
        before { repo.assert_remote_url('origin', '/remote1') }

        it { expect(repo.git.remote('origin').url).to eq('/remote1') }

        context 'after asserted remote URL "/remote2"' do # rubocop:disable RSpec/ContextWording, :
          before { repo.assert_remote_url('origin', '/remote2') }

          it { expect(repo.git.remote('origin').url).to eq('/remote2') }
        end
      end
    end
  end
end
