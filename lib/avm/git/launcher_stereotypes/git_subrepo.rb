# frozen_string_literal: true

module Avm
  module Git
    module LauncherStereotypes
      class GitSubrepo
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
            configuration(path).remote_uri ||
              raise(::Avm::Git::Launcher::Error.new(path, '"remote = ... " not found'))
          end

          private

          # @return [EacGit::Subrepo::Configuration]
          def configuration(path)
            ::EacGit::Subrepo::Configuration.from_file(path.subpath(CONFIG_SUBPATH))
          end
        end
      end
    end
  end
end
