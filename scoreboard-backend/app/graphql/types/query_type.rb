module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :scores, [String], null: false,
      description: "An example field added by the generator"
    def scores
      Score.all
    end
  end
end
