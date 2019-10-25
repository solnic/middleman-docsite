# frozen_string_literal: true

RSpec.describe Middleman::Docsite do
  subject(:site) do
    Middleman::Docsite
  end

  let(:projects) { Middleman::Docsite.projects }

  describe '#projects' do
    it 'returns projects loaded from data/projects.yml' do
      expect(projects.size).to be(4)

      p1, p2, p3 = projects

      expect(p1.name).to eql('Repo Project')
      expect(p1.repo?).to be(true)
      expect(p1.repo).to eql('https://some.repo.git')
      expect(p1.versions).to eql(['0.1', '0.2'])

      expect(p2.name).to eql('Test Project')
      expect(p2.repo?).to be(false)
      expect(p2.versions).to eql(['0.1', '0.2'])

      expect(p3.name).to eql('middleman-docsite')
      expect(p3.repo?).to be(true)
      expect(p3.repo).to eql('https://github.com/solnic/middleman-docsite.git')
      expect(p3.versions).to eql([{ value: '0.1', branch: 'doc-importer' }])
    end
  end

  describe '#clone_repo' do
    let(:project) do
      projects.detect { |project| project.name.eql?('middleman-docsite') }
    end

    it 'clones project repository' do
      site.clone_repo(project)

      expect(site.projects_dir.join('middleman-docsite')).to exist
    end

    it 'updates project repository when clone exists' do
      2.times { site.clone_repo(project) }

      expect(site.projects_dir.join('middleman-docsite')).to exist
    end
  end

  describe '#symlink_repo' do
    context 'with a top-level project' do
      let(:project) do
        projects.detect { |project| project.name.eql?('middleman-docsite') }
      end

      it 'symlinks project repository' do
        site.clone_repo(project, branch: 'doc-importer')

        site.symlink_repo(project, branch: 'doc-importer')

        symlink_path = site.root.join('source/gems/middleman-docsite/0.1')

        expect(symlink_path).to exist

        source_files = Dir[symlink_path.join('**/*.*')]
          .map(&Pathname.method(:new)).map(&:basename)

        target_files = Dir[FIXTURES.join('test-gem/docsite/**/*.*')]
          .map(&Pathname.method(:new)).map(&:basename)

        expect(source_files).to eql(target_files)
      end
    end

    context 'with a sub-project' do
      let(:project) do
        projects.detect { |project| project.name.eql?('sub-project') }
      end

      it 'symlinks sub-project dir from the repository' do
        site.clone_repo(project, branch: 'master')

        site.symlink_repo(project, branch: 'master')

        symlink_path = site.root.join('source/gems/sub-project/0.3')

        expect(symlink_path).to exist

        source_files = Dir[symlink_path.join('**/*.*')]
          .map(&Pathname.method(:new)).map(&:basename)

        target_files = Dir[FIXTURES.join('test-gem/sub_project/docsite/**/*.*')]
          .map(&Pathname.method(:new)).map(&:basename)

        expect(source_files).to eql(target_files)
      end
    end
  end
end
