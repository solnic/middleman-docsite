# frozen_string_literal: true

require 'yaml'
require 'pathname'
require "open3"

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
        .sort_by(&:name)
    end

    def self.data_path
      root.join('data')
    end

    def self.development?
      ENV['BUILD'] != 'true'
    end

    def self.clone_repo(project, branch: 'master')
      repo = project.repo
      name = "#{project.name}/#{branch}"
      dest = projects_dir.join(name)

      if dest.exist?
        puts "Updating #{name} clone"
        shell 'git pull --rebase', chdir: dest
      else
        puts "Cloning #{branch} branch from #{repo} to projects/#{name}"

        shell(
          "git clone --single-branch --branch #{branch} #{repo} #{name}",
          chdir: projects_dir
        )
      end
    end

    def self.symlink_repo(project, options = {})
      branch = options.fetch(:branch)

      name = project.name
      version = project.version_from_branch(branch)

      clone_dir = projects_dir.join(name).join(branch)

      from = clone_dir.join('docsite/source').realpath
      dir = source_dir.join(name)
      link = dir.join(version)

      FileUtils.mkdir_p(dir)

      puts "Symlinking #{link.to_s.gsub("#{root}/", '')} => #{from.to_s.gsub("#{root}/", "")}"

      shell "ln -sf #{from} #{link}"
    end

    def self.projects_dir
      root.join('projects')
    end

    def self.source_dir
      root.join('source/gems')
    end

    def self.shell(cmd, opts = {})
      Open3.popen3(cmd, opts) { |_stdin, _stdout, stderr, wait_thr|
        status = wait_thr.value

        unless status.success?
          puts "shell command crashed: #{stderr.read}"
          exit status.to_i
        end
      }
    end
  end
end
