# frozen_string_literal: true

require 'dry/types'

module Middleman
  module Docsite
    module Types
      include Dry.Types

      Repo = Types::String.constrained(filled: true)

      Version = Types::Hash
        .schema(
          value: Types::String,
          branch?: Types::String,
          tag?: Types::String,
          dir?: Types::String,
          component?: Types::Bool
        )
        .with_key_transform(&:to_sym)

      Versions = Types::Array.of(String | Version)
    end
  end
end
