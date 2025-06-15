# frozen_string_literal: true

module Avm
  module Git
    module Runners
      class Base
        class DirtyFiles
          DEFAULT_FORMAT = '%p'
          FIELDS = {
            i: :index, w: :worktree, p: :path, a: :absolute_path
          }.transform_keys { |k| "%#{k}" }

          runner_with :help do
            desc 'Lists dirty files in Git repository.'
            arg_opt '-f', '--format',
                    "Format of each line (See \"Format fields\") [default: #{DEFAULT_FORMAT}]."
          end

          def help_extra_text
            "Format fields:\n" + FIELDS.map { |k, v| "  #{k} => #{v}" }.join("\n") # rubocop:disable Style/StringConcatenation
          end

          def run
            runner_context.call(:git).dirty_files.each do |file|
              out("#{format_file(file)}\n")
            end
          end

          private

          def format
            parsed.format || DEFAULT_FORMAT
          end

          def format_file(file)
            FIELDS.inject(format) { |a, e| a.gsub(e.first, file.send(e.last)) }
          end
        end
      end
    end
  end
end
