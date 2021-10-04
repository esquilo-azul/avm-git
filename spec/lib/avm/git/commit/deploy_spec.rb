# frozen_string_literal: true

require 'avm/git/commit'
require 'avm/git/commit/deploy'
require 'eac_ruby_utils/fs/temp'

RSpec.describe ::Avm::Git::Commit::Deploy, git: true do
  class << self
    FROM_DEPLOY = %w[a.txt b.txt c.txt appended].freeze # rubocop:disable RSpec/LeakyConstantDeclaration
    NOT_FROM_DEPLOY = %w[to_be_removed].freeze # rubocop:disable RSpec/LeakyConstantDeclaration

    def check_files(from_deploy_exist)
      if from_deploy_exist
        check_files_exist(FROM_DEPLOY)
        check_files_not_exist(NOT_FROM_DEPLOY)
      else
        check_files_not_exist(FROM_DEPLOY)
        check_files_exist(NOT_FROM_DEPLOY)
      end
    end

    def check_file_exist(basename)
      it("expect \"#{basename}\" to exist") { expect(target_dir.join(basename)).to exist }
    end

    def check_file_not_exist(basename)
      it("expect \"#{basename}\" to not exist") { expect(target_dir.join(basename)).not_to exist }
    end

    def check_files_exist(basenames)
      basenames.each { |basename| check_file_exist(basename) }
    end

    def check_files_not_exist(basenames)
      basenames.each { |basename| check_file_not_exist(basename) }
    end
  end

  let(:git) { stubbed_git_local_repo }

  let(:commit_sha1) do
    git.file('a.txt').write('AAA')
    git.file('b.txt').write('BBB')
    git.command('add', '.').execute!
    git.command('commit', '-m', 'First commit.').execute!
    git.rev_parse('HEAD')
  end

  let(:appended_dir) do
    r = ::EacRubyUtils::Fs::Temp.directory
    r.join('appended.template').write('Needs a %%ABC%% value.')
    r
  end

  let(:target_dir) do
    r = ::EacRubyUtils::Fs::Temp.directory
    ::FileUtils.touch(r.join('to_be_removed').to_path)
    r
  end

  let(:commit) { ::Avm::Git::Commit.new(git, commit_sha1) }
  let(:variables_source_class) do
    ::Class.new do
      attr_reader :abc

      def initialize(abc)
        @abc = abc
      end
    end
  end
  let(:variables_source) { variables_source_class.new('Any value') }
  let(:target_env) { ::EacRubyUtils::Envs.local }
  let(:instance) do
    described_class.new(commit, target_env, target_dir).append_templatized_directory(appended_dir)
                   .append_file_content('c.txt', 'Any content')
                   .variables_source_set(variables_source)
  end

  after do
    appended_dir.remove
    target_dir.remove
  end

  context 'without run' do # rubocop:disable RSpec/EmptyExampleGroup
    check_files(false)
  end

  context 'with run' do # rubocop:disable RSpec/EmptyExampleGroup
    before { instance.run }

    check_files(true)
  end
end
