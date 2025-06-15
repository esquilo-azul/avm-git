# frozen_string_literal: true

module Avm
  module Git
    module ApplicationScms
      class Base < ::Avm::ApplicationScms::Base
        acts_as_abstract

        # @return [Addressable::URI]
        def git_https_url
          raise_abstract_method __method__
        end

        require_sub __FILE__, require_mode: :kernel
      end
    end
  end
end
