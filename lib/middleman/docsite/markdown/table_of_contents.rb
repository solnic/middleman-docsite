# frozen_string_literal: true

module Middleman
  module Docsite
    module Markdown
      module TableOfContents
        # Preprocessor to add quick links at the top of a docs page.
        #
        # @example
        #   $TOC
        #     1. [Introduction](#introduction)
        #     2. [Getting Started](#getting-started)
        #   $TOC
        def table_of_contents(document, markdown)
          document.gsub(/^(?:^)\$TOC(.*?)\$TOC *(\r|\n|$)?+/msu) do
            <<~HTML
              <div class="toc">
                <h2 id="toc">Contents</h2>
                #{markdown.render(Regexp.last_match(1))}
              </div>
            HTML
          end
        end
      end
    end
  end
end
