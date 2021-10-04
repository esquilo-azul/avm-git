# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    class Commit
      module ClassMethods
        common_concern

        module ClassMethods
          def target_url_to_env_path(target_url)
            uri = ::Addressable::URI.parse(target_url)
            uri.scheme = 'file' if uri.scheme.blank?
            [uri_to_env(uri), uri.path]
          end

          private

          def uri_to_env(uri)
            case uri.scheme
            when 'file' then ::EacRubyUtils::Envs.local
            when 'ssh' then ::EacRubyUtils::Envs.ssh(uri)
            else "Invalid schema \"#{uri.schema}\" (URI: #{uri})"
            end
          end
        end
      end
    end
  end
end
