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

      expect(p2.name).to eql('middleman-docsite')
      expect(p2.repo?).to be(true)
      expect(p2.repo).to eql('https://github.com/solnic/middleman-docsite.git')
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
end
