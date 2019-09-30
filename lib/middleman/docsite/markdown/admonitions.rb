module Middleman
  module Docsite
    module Markdown
      module Admonitions
        def admonition(document, markdown, type:, label:)
          document.gsub(/^(?:^)\^#{type.upcase}(.*?)\^ *(\r|\n|$)?+/msu) do
            <<~HTML
              <div role="note" aria-label="#{label}" class="application-notice #{type}-notice">
                <div class="notice-title">
                  <i class="fa fa-info-circle"></i> #{label}
                </div>
                #{markdown.render(Regexp.last_match(1))}
              </div>
            HTML
          end
        end

        # Preprocessor to wrap the contents of '^INFO' marks in a nice notice box
        #
        # @example
        #   ^INFO
        #    Multi-line notice message which will display in
        #    in a nice blue notice box.
        #   ^
        def information(*args)
          admonition(*args, type: :info, label: "Info")
        end

        # Preprocessor to wrap the contents of '^WARNING' marks in a warning html notice
        #
        # @example
        #   ^WARNING
        #    Multi-line notice message which will display in
        #    in a red warning box.
        #   ^
        def warning(*args)
          admonition(*args, type: :warning, label: "Warning")
        end
      end
    end
  end
end
