# frozen_string_literal: true

require 'avm/git/subrepo_check'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    class SubrepoChecks
      enable_speaker
      enable_simple_cache
      attr_accessor :check_remote, :fix_parent
      common_constructor :repository

      def add_all_subrepos
        add_subrepos(
          *repository.command('subrepo', '-q', 'status').execute!.split("\n").map(&:strip)
          .select(&:present?)
        )
      end

      def add_subrepos(*subpath_list)
        subpath_list.each do |subpath|
          subpaths.add(subpath)
        end
        reset_cache
        self
      end

      def check_options
        { fix_parent: fix_parent, check_remote: check_remote }
      end

      def show_result
        checks.each(&:show_result)
        infov 'Result', result.label
      end

      private

      def checks_uncached
        subpaths.map do |subpath|
          ::Avm::Git::SubrepoCheck.new(repository.subrepo(subpath), check_options)
        end
      end

      def result_uncached
        error_count = checks.count { |check| check.result.error? }
        ::Avm::Result.success_or_error(
          error_count.zero?,
          "#{error_count} of #{checks.count} subrepos failed"
        )
      end

      def subpaths
        @subpaths ||= ::Set.new
      end
    end
  end
end
