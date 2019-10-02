# frozen_string_literal: true

RSpec.describe Middleman::Docsite do
  subject(:site) do
    Middleman::Docsite
  end

  let(:projects) { Middleman::Docsite.projects }

  describe '#projects' do
    it 'returns projects loaded from data/projects.yml' do
      expect(projects.size).to be(2)

      p1, p2 = projects

      expect(p1.name).to eql('Test Project')
      expect(p1.repo?).to be(false)
      expect(p1.versions).to eql(['0.1', '0.2'])

      expect(p2.name).to eql('middleman-docsite')
      expect(p2.repo?).to be(true)
      expect(p2.repo).to eql('https://github.com/solnic/middleman-docsite.git')
      expect(p2.versions).to eql([{ version: '0.1', branch: 'doc-importer' }])
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
  end

  describe '#symlink_repo' do
    let(:project) do
      projects.detect { |project| project.name.eql?('middleman-docsite') }
    end

    it 'symlink project repository' do
      site.clone_repo(project)

      site.symlink_repo(project, branch: 'doc-importer')

      symlink_path = site.root.join('source/gems/middleman-docsite/0.1')

      expect(symlink_path).to exist

      source_files = Dir[symlink_path.join('**/*.*')]
        .map(&Pathname.method(:new)).map(&:basename)

      target_files = Dir[site.root.join('../docsite/**/*.*')]
        .map(&Pathname.method(:new)).map(&:basename)

      expect(source_files).to eql(target_files)
    end
  end
end
