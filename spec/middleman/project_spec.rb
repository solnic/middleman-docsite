require 'middleman/docsite/project'

RSpec.describe Middleman::Docsite::Project do
  subject(:project) do
    Middleman::Docsite::Project.new(name: 'test-project', **attributes)
  end

  describe '#latest_version' do
    context "with plain version strings" do
      let(:attributes) do
        { versions: ['1.2.0', '2.4.1'] }
      end

      it 'returns the latest version' do
        expect(project.latest_version).to eql("2.4.1")
      end
    end

    context "with version hashes" do
      let(:attributes) do
        { versions: [{ value: '1.2.0' }, { value: '2.4.1' }] }
      end

      it 'returns the latest version' do
        expect(project.latest_version).to eql("2.4.1")
      end
    end

    context "with master" do
      let(:attributes) do
        { versions: [{ value: 'master' }] }
      end

      it 'returns master as the latest version' do
        expect(project.latest_version).to eql("master")
      end
    end
  end
end
