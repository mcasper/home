module Types
  class MatchType < Types::BaseObject
    field :id, ID, null: false
    field :player_one, String, null: false
    field :player_two, String, null: false
    field :game, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :score_changes, [Types::ScoreChangeType], null: false
  end
end
