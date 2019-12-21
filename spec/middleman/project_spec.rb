require 'middleman/docsite/project'

RSpec.describe Middleman::Docsite::Project do
  subject(:project) do
    Middleman::Docsite::Project.new(name: 'test-project', versions: ['1.2.0', '2.4.1'])
  end

  describe '#latest_version' do
    it 'returns the latest version' do
      expect(project.latest_version).to eql("2.4.1")
    end
  end
end
