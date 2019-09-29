# frozen_string_literal: true

require 'yaml'
require 'pathname'

require 'middleman/docsite/version'
require 'middleman/docsite/project'
require 'middleman/docsite/markdown'

module Middleman
  module Docsite
    class << self
      attr_accessor :project_class
      attr_accessor :root
    end

    self.root = Dir.pwd
    self.project_class = Docsite::Project

    def self.projects
      @projects ||= YAML.load_file(data_path.join('projects.yml'))
        .map(&project_class.method(:new))
    end

    def self.data_path
      root.join('data')
    end

    def self.development?
      ENV['BUILD'] != 'true'
    end
  end
end
