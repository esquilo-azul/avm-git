# frozen_string_literal: true

module Avm
  module Git
    module Launcher
      class Base < ::Avm::Launcher::Paths::Real
        module Subrepo
          def subrepo_status(subrepo_path)
            s = execute!('subrepo', 'status', subrepo_path.gsub(%r{\A/}, ''))
            raise s.strip.to_s if s.include?('is not a subrepo')

            r = subrepo_status_parse_output(s)
            raise "Empty subrepo status for |#{s}|\n" unless r.any?

            r
          end

          def subrepo_remote_url(subrepo_path)
            h = subrepo_status(subrepo_path)
            url = h['Remote URL']
            return url if url.present?

            raise "Remote URL is blank for subrepo \"#{subrepo_path}\" (Subrepo status: #{h})"
          end

          private

          def subrepo_status_parse_output(output)
            r = {}.with_indifferent_access
            output.each_line do |l|
              m = /\A([^\:]+):(.*)\z/.match(l.strip)
              next unless m && m[2].present?

              r[m[1].strip] = m[2].strip
            end
            r
          end
        end
      end
    end
  end
end
