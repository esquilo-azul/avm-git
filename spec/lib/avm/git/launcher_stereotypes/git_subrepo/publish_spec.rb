# frozen_string_literal: true

require 'avm/git/launcher_stereotypes/git_subrepo/publish'
require 'avm/launcher/publish/check_result'

RSpec.describe Avm::Git::LauncherStereotypes::GitSubrepo::Publish do
  include_context 'with_launcher'
  include_examples 'with_config', __FILE__

  describe '#check' do
    context 'with clean context' do
      let(:settings_path) { File.join(__dir__, 'publish_spec_settings.yml') }

      before do
        temp_context(settings_path)
      end

      context 'with app with subrepo' do
        let(:remote_repos) { init_remote('mylib') }

        before do
          wc = init_git('mylib')
          touch_commit(wc, 'file1')
          wc.execute!('remote', 'add', 'publish', remote_repos)
          wc.execute!('push', 'publish', 'master')
        end

        let!(:app) do # rubocop:disable RSpec/ScatteredLet
          r = init_git('app')
          touch_commit(r, 'file2')
          r.execute!('subrepo', 'clone', remote_repos, 'mylib')
          launcher_controller.application_source_path('app', r.root_path)
          r
        end

        it { check_publish_status(:updated) } # rubocop:disable RSpec/NoExpectationExample

        context 'after subrepo updated and before publishing' do # rubocop:disable RSpec/ContextWording
          before do
            Avm::Launcher::Context.current.publish_options[:confirm] = true
            touch_commit(app, 'mylib/file3')
          end

          it { expect(Avm::Launcher::Context.current.publish_options[:confirm]).to be(true) }
          it { check_publish_status(:pending) } # rubocop:disable RSpec/NoExpectationExample

          context 'after publishing' do # rubocop:disable RSpec/ContextWording
            before { described_class.new(app_mylib_instance).run }

            it { check_publish_status(:updated) } # rubocop:disable RSpec/NoExpectationExample

            context 'after reset context' do # rubocop:disable RSpec/ContextWording
              before do
                sleep 2
                launcher_controller.temp_context(settings_path)
              end

              it { check_publish_status(:updated) } # rubocop:disable RSpec/NoExpectationExample
            end
          end
        end

        def check_publish_status(status_key) # rubocop:disable Metrics/AbcSize
          instance = app_mylib_instance
          expect(instance).to be_a(Avm::Launcher::Instances::Base)
          expect(instance.stereotypes).to include(Avm::Git::LauncherStereotypes::GitSubrepo)

          status = Avm::Launcher::Publish::CheckResult.const_get("STATUS_#{status_key}".upcase)
          publish = described_class.new(instance)
          expect(publish.check.status).to(
            eq(status),
            "Expected: #{status}, Actual: " \
            "#{publish.check.status}, Message: #{publish.check.message}"
          )
        end

        def app_mylib_instance
          Avm::Launcher::Context.current.instance('/app/mylib')
        end
      end
    end
  end
end
