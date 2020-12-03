module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :matches, [Types::MatchType], null: false,
      description: "An example field added by the generator"
    def matches
      Match.preload(:score_changes).all
    end
  end
end
