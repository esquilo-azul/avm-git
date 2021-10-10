# frozen_string_literal: true

require 'avm/registry'
require 'avm/git/scms/git'

::RSpec.describe ::Avm::Git::Scms::Git do
  include_examples 'in_avm_registry', 'scms'
end
