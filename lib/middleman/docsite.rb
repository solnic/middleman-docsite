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
    setting :projects_subdir, 'gems', reader: true
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

    def self.clone_repo(project, branch: 'master')
      repo = project.repo_url
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

    # rubocop:disable Metrics/AbcSize
    def self.symlink_repo(project, options)
      branch = options.fetch(:branch)
      dir = options[:dir]
      component = options.fetch(:component, false)

      clone_dir =
        if dir && !component
          projects_dir.join(project.name).join(branch).join(dir)
        else
          projects_dir.join(project.name).join(branch)
        end

      from =
        if component
          clone_dir.join("docsite/#{project.slug}/source").realpath
        else
          clone_dir.join('docsite/source').realpath
        end

      version = project.version_from_branch(branch)
      dir = source_dir.join(project.slug)
      link = dir.join(version)

      return if link.exist?

      FileUtils.mkdir_p(dir) unless dir.exist?

      puts "Symlinking #{link.to_s.gsub("#{root}/", '')} => #{from.to_s.gsub("#{root}/", "")}"

      shell "ln -sf #{from} #{link}"
    end
    # rubocop:enable Metrics/AbcSize

    def self.projects_dir
      root.join('projects')
    end

    def self.source_dir
      root.join("source/#{projects_subdir}")
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
