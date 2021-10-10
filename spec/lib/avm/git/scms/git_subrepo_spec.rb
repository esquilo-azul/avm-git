# frozen_string_literal: true

require 'avm/registry'
require 'avm/git/scms/git_subrepo'

::RSpec.describe ::Avm::Git::Scms::GitSubrepo do
  include_examples 'in_avm_registry', 'scms'
end
