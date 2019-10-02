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

      return if dest.exist?

      puts "Cloning #{repo} to #{dest}"

      system "git clone #{repo} #{dest}"
    end

    def self.symlink_repo(project, branch:)
      name = project.name

      system "cd #{projects_dir.join(name)} && git checkout #{branch}"

      from = projects_dir.join(name).join('docsite/source').realpath
      dir = source_dir.join(name)
      link = dir.join(branch)

      FileUtils.mkdir_p(dir)

      puts "Symlinking #{from} => #{link}"

      system "ln -s #{from} #{link}"
    end

    def self.projects_dir
      root.join('projects')
    end

    def self.source_dir
      root.join('source/gems')
    end
  end
end
