# frozen_string_literal: true

require 'eac_cli/core_ext'

module Avm
  module Git
    module Runners
      class Base
        class Subrepo
          require_sub __FILE__
          runner_with :help, :subcommands do
            desc 'Git-subrepo (https://github.com/ingydotnet/git-subrepo) utilities.'
            subcommands
          end
        end
      end
    end
  end
end
