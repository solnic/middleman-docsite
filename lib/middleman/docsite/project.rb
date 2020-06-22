# frozen_string_literal: true

require 'dry/struct'
require 'middleman/docsite/types'

module Middleman
  module Docsite
    class Project < Dry::Struct
      Types = Middleman::Docsite::Types

      transform_keys(&:to_sym)

      transform_types do |type|
        if type.default?
          type.constructor do |value|
            value.nil? ? Dry::Types::Undefined : value
          end
        else
          type
        end
      end

      attribute :name, Types::String
      attribute? :slug, Types::String
      attribute? :repo, Types::Repo
      attribute? :versions, Types::Versions

      alias_method :to_s, :slug

      def component?
        repo? && repo.is_a?(Hash) && repo[:component].equal?(true)
      end

      def repo?
        !repo.nil?
      end

      def repo_url
        repo.is_a?(Hash) ? repo[:url] : repo
      end

      def dir_name
        sub_project? ? repo[:dir] : name
      end

      def slug
        @attributes[:slug] || name
      end

      def sub_project?
        repo.is_a?(Hash) && repo[:dir] && !component?
      end

      def version_from_branch(branch)
        versions.detect { |version| version[:branch].eql?(branch) }.fetch(:value)
      end

      def latest_version
        (versions
          .map { |v| v.is_a?(Hash) ? v[:value] : v }
          .reject { |value| value.eql?('master') }
          .map(&Gem::Version.method(:new))
          .max || 'master').to_s
      end

      def github_url
        "https://github.com/#{org}/#{name}"
      end

      def rubygems_url
        "https://rubygems.org/gems/#{name}"
      end

      def version_badge
        "https://badge.fury.io/rb/#{name}.svg"
      end

      def ci_badge
        "https://img.shields.io/travis/#{org}/#{name}/master.svg?style=flat"
      end

      def codeclimate_url
        "https://codeclimate.com/github/#{org}/#{name}"
      end

      def codeclimate_badge
        "https://codeclimate.com/github/#{org}/#{name}/badges/gpa.svg"
      end

      def coverage_badge
        "https://codeclimate.com/github/#{org}/#{name}/badges/coverage.svg"
      end

      def inch_url
        "http://inch-ci.org/github/#{org}/#{name}"
      end

      def inch_badge
        "http://inch-ci.org/github/#{org}/#{name}.svg?branch=master&style=flat"
      end

      def api_url
        "#{api_host_url}/#{name}"
      end

      def api_host_url
        Docsite.development? ? 'http://localhost:4000/docs' : "https://api.#{org}.org"
      end
    end
  end
end
