# frozen_string_literal: true

module Avm
  module Git
    module LauncherStereotypes
      class GitSubrepo
        require_sub __FILE__
        include Avm::Launcher::Stereotype

        CONFIG_SUBPATH = '.gitrepo'

        class << self
          def match?(path)
            File.exist?(path.real.subpath(CONFIG_SUBPATH)) && subrepo_url(path.real) != 'none'
          end

          def color
            :light_cyan
          end

          def subrepo_url(path)
            File.read(path.subpath(CONFIG_SUBPATH)).each_line do |l|
              m = /remote\s*=\s(.+)/.match(l)
              return m[1] if m
            end
            raise ::Avm::Git::Launcher::Error.new(path, '"remote = ... " not found')
          end
        end
      end
    end
  end
end
