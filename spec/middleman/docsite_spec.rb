# frozen_string_literal: true

RSpec.describe Middleman::Docsite do
  it 'loads projects from data YAML' do
    project = Middleman::Docsite.projects.first

    expect(project.name).to eql('Test Project')
  end
end
