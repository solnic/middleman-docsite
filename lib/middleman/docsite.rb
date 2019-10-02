# frozen_string_literal: true

require 'yaml'
require 'pathname'

require 'middleman/docsite/version'
require 'middleman/docsite/project'
require 'middleman/docsite/markdown'

require 'dry/configurable'

module Middleman
  module Docsite
    extend Dry::Configurable

    setting :project_class, Docsite::Project, reader: true
    setting :root, Pathname(Dir.pwd).realpath, reader: true

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

    def self.clone_repo(project)
      repo = project.repo
      name = project.name
      dest = projects_dir.join(name)

      puts "Cloning #{repo} to #{dest}"

      system "git clone #{repo} #{dest}"
    end

    def self.projects_dir
      root.join('projects')
    end
  end
end
