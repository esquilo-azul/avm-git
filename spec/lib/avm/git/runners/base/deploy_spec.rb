# frozen_string_literal: true

require 'avm/eac_ubuntu_base0/rspec/ssh_docker_server'
require 'avm/git/runners/base'
require 'tmpdir'

RSpec.describe Avm::Git::Runners::Base::Deploy, :git do
  let(:git) { stubbed_git_local_repo }
  let(:reference) { git.current_branch }
  let(:stub_file1) { 'stub1.txt' }
  let(:stub_content1) { 'CONTENT 111' }
  let(:stub_file2) { 'stub2.txt' }
  let(:stub_content2) { 'CONTENT 222' }
  let(:commit_sha1) do
    git.file(stub_file1).write(stub_content1)
    git.command('add', stub_file1).execute!
    git.command('commit', '-m', 'First commit.').execute!
    git.rev_parse('HEAD')
  end
  let(:append_dirs) do
    [1, 2].map { |n| File.join(__dir__, 'deploy_spec_files', "append#{n}") }.join(':')
  end
  let(:target_dir) { File.join(Dir.mktmpdir, 'target') }

  let(:commit_sha2) do
    git.command('checkout', commit_sha1).execute!
    git.file(stub_file1).delete
    git.file(stub_file2).write(stub_content2)
    git.command('add', stub_file1, stub_file2).execute!
    git.command('commit', '-m', 'Second commit.').execute!
    git.rev_parse('HEAD')
  end

  let(:target_stub_file1) { File.join(target_dir, stub_file1) }
  let(:target_stub_file2) { File.join(target_dir, stub_file2) }

  context 'with local target' do
    before do
      commit_sha1
      avm_tools_runner_run(target_dir)
    end

    it { expect(File.read(target_stub_file1)).to eq(stub_content1) }
    it { expect(File.exist?(target_stub_file2)).to be(false) }

    context 'with second commit' do
      before do
        commit_sha2
        avm_tools_runner_run(target_dir)
      end

      it { expect(File.exist?(target_stub_file1)).to be(false) }
      it { expect(File.read(target_stub_file2)).to eq(stub_content2) }
    end
  end

  context 'with append directories' do
    let(:target_stub_file3) { File.join(target_dir, 'stub3.txt') }
    let(:target_stub_file4) { File.join(target_dir, 'stub4.txt') }

    before do
      EacConfig::Node.context.current.entry('my_value').value = '123'
      commit_sha1
      avm_tools_runner_run('--append-dirs', append_dirs, target_dir)
    end

    it { expect(File.read(target_stub_file1)).to eq(stub_content1) }
    it { expect(File.exist?(target_stub_file2)).to be(false) }
    it { expect(File.read(target_stub_file3)).to eq("MyValue: 123\n") }
    it { expect(File.read(target_stub_file4)).to eq("MyValue: %%MY_VALUE%%\n") }
  end

  context 'with instance' do
    let(:target_stub_file3) { File.join(target_dir, 'stub3.txt') }
    let(:target_stub_file4) { File.join(target_dir, 'stub4.txt') }

    before do
      EacConfig::Node.context.current.entry('my-instance_dev.my_value').value = '123'
      commit_sha1
      avm_tools_runner_run('-i', 'my-instance_dev', '--append-dirs', append_dirs, target_dir)
    end

    it { expect(File.read(target_stub_file1)).to eq(stub_content1) }
    it { expect(File.exist?(target_stub_file2)).to be(false) }
    it { expect(File.read(target_stub_file3)).to eq("MyValue: 123\n") }
    it { expect(File.read(target_stub_file4)).to eq("MyValue: %%MY_VALUE%%\n") }
  end

  context 'with ssh target', :docker do
    let(:ssh_server) { Avm::EacUbuntuBase0::Rspec::SshDockerServer.new }
    let(:env) { ssh_server.env }
    let(:tmpdir) { env.command('mktemp', '-d').execute! }
    let(:target_dir) { File.join(tmpdir, 'target') }
    let(:target_url) do
      r = env.uri.dup
      r.path = target_dir
      r.to_s
    end

    around do |example|
      ssh_server.on_run(&example)
    end

    before do
      commit_sha1
      avm_tools_runner_run(target_url)
    end

    it { expect(env.file(target_stub_file1).read).to eq(stub_content1) }
    it { expect(env.file(target_stub_file2).exist?).to be(false) }

    context 'with second commit' do
      before do
        commit_sha2
        avm_tools_runner_run(target_url)
      end

      it { expect(env.file(target_stub_file1).exist?).to be(false) }
      it { expect(env.file(target_stub_file2).read).to eq(stub_content2) }
    end
  end

  def avm_tools_runner_args_prefix
    ['git', '-C', git.root_path.to_path, 'deploy']
  end
end
