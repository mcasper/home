module Types
  class ScoreChangeType < Types::BaseObject
    field :id, ID, null: false
    field :player, String, null: false
    field :change, Integer, null: false
    field :match_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
