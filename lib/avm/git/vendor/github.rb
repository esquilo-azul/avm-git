# frozen_string_literal: true

module Avm
  module Git
    module Vendor
      module Github
        class << self
          def to_ssh_url(url)
            return nil if url.blank?

            url_no_dot_git = url.gsub(/\.git\z/, '')

            m = %r{\Ahttps://github.com/([^/]+)/([^/]+)\z}.match(url_no_dot_git.to_s)
            m ? "git@github.com:#{m[1]}/#{m[2]}.git" : url
          end
        end
      end
    end
  end
end
