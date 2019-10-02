require 'dry/types'

module Middleman
  module Docsite
    module Types
      include Dry.Types

      Version = Types::Hash
        .schema(
          version: Types::String,
          branch?: Types::String,
          tag?: Types::String
        )
        .with_key_transform(&:to_sym)

      Versions = Types::Array.of(String | Version)
    end
  end
end
