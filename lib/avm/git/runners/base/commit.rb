# frozen_string_literal: true

require 'eac_cli/speaker'
require 'eac_ruby_utils/simple_cache'
require 'avm/git/launcher/base'
require 'filesize'
require 'avm/git/commit'

module Avm
  module Git
    module Runners
      class Base
        class Commit
          runner_with :help do
            desc 'Mostra informações de um commit.'
            bool_opt '-f', '--files', 'Mostra os arquivos.'
            bool_opt '-s', '--size', 'Mostra o tamanho de arquivos.'
            pos_arg :ref
          end

          def run
            input_banner
            validate
            main_info_banner
            files_banner
            size_banner
          end

          private

          def input_banner
            infov 'Repository', git
            infov 'Reference', reference
          end

          def validate
            return if reference_id.present?

            fatal_error "Object ID not found for reference \"#{reference}\""
          end

          def main_info_banner
            infov 'Reference ID', reference_id
            infov 'Subject', commit.subject
            infov 'Author', commit.author_all
            infov 'Commiter', commit.commiter_all
            infov 'Files', commit.files.count
          end

          def size_banner
            return unless show_size?

            infov 'Total files size', bytes_size(commit.files_size)
          end

          def files_banner
            return unless parsed.files?

            commit.files.each do |file|
              infov "  #{file.path}", file_value(file)
            end
          end

          def file_value(file)
            s = file.status
            s += ", #{bytes_size(file.dst_size)}" if show_size?
            s
          end

          def reference_id
            git.rev_parse(reference)
          end

          def reference
            parsed.ref
          end

          def git_uncached
            ::Avm::Git::Launcher::Base.new(runner_context.call(:repository_path))
          end

          def commit_uncached
            ::Avm::Git::Commit.new(git, reference_id)
          end

          def human_files_size
            ::Filesize.from("#{commit.files_size} B").pretty
          end

          def bytes_size(size)
            b = "#{size} B"
            "#{::Filesize.from(b).pretty} (#{b})"
          end

          def show_size?
            parsed.size?
          end
        end
      end
    end
  end
end
