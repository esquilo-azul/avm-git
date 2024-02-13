# frozen_string_literal: true

require 'avm/git/scms/git'
require 'eac_config/node'

module Avm
  module Git
    module Runners
      class Base
        class Deploy
          DEFAULT_REFERENCE = 'HEAD'

          runner_with :help do
            desc 'Deploy a Git revision to a location (Local or remote).'
            arg_opt '-a', '--append-dirs', 'Append directories to deploy (List separated by ":").'
            arg_opt '-i', '--instance', 'Read entries from instance with id=<instance-id>.'
            arg_opt '-r', '--reference', "Reference (default: #{DEFAULT_REFERENCE})."
            pos_arg :target_url, optional: true
          end

          def run
            input_banner
            validate
            main_info_banner
            deploy
            success 'Done'
          end

          private

          def input_banner
            infov 'Repository', git
            infov 'Reference', reference
            infov 'Instance ID', instance_id.if_present('- BLANK -')
            infov 'Appended directories', appended_directories
            infov 'Target URL', target_url
          end

          def validate
            if reference_sha1.blank?
              fatal_error "Object ID not found for reference \"#{reference}\""
            end
            fatal_error 'Nor <target-url> nor --instance was setted' if target_url.blank?
          end

          def main_info_banner
            infov 'Reference SHA1', reference_sha1
          end

          def reference_sha1_uncached
            git.git_repo.rev_parse(reference)
          end

          def reference
            parsed.reference || DEFAULT_REFERENCE
          end

          def git_uncached
            ::Avm::Git::Scms::Git.new(git_repository_path)
          end

          def git_repository_path
            if runner_context.call(:repository_path) || dev_instance_fs_path.blank?
              return runner_context.call(:repository_path)
            end

            dev_instance_fs_path
          end

          def dev_instance_fs_path
            instance.if_present do |v|
              v.application.instance('dev').read_entry_optional(
                ::Avm::Instances::EntryKeys::INSTALL_PATH
              )
            end
          end

          def deploy
            git.commit(reference_sha1)
              .deploy_to_url(target_url)
              .append_templatized_directories(appended_directories)
              .variables_source_set(variables_source)
              .run
          end

          def target_url
            parsed.target_url.if_present { |v| return v }
            instance.if_present { |v| return v.install_url }
            nil
          end

          def variables_source
            instance || ::EacConfig::Node.context.current
          end

          def instance_uncached
            instance_id.if_present { |v| ::Avm::Instances::Base.by_id(v) }
          end

          def instance_id
            parsed.instance
          end

          def appended_directories
            parsed.append_dirs.to_s.split(':')
          end
        end
      end
    end
  end
end
