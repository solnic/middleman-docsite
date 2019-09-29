# frozen_string_literal: true

require 'middleman/docsite/markdown/admonitions'
require 'middleman/docsite/markdown/table_of_contents'

module Middleman
  module Docsite
    module Markdown
      module Preprocessors
        include Docsite::Markdown::Admonitions
        include Docsite::Markdown::TableOfContents

        def preprocess(document)
          renderer = self.class.new(@local_options)
          parser = Redcarpet::Markdown.new(renderer, @local_options)

          rendered_doc = table_of_contents(document, parser)
          rendered_doc = information(rendered_doc, parser)
          rendered_doc = warning(rendered_doc, parser)

          rendered_doc
        end
      end
    end
  end
end
