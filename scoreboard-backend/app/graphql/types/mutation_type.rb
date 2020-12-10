module Types
  class MutationType < Types::BaseObject
    field :create_score_change, Types::MatchType, null: false,
      description: "An example field added by the generator" do
      argument :player, String, required: true
      argument :change, Integer, required: true
      argument :match_id, Integer, required: true
    end
    def create_score_change(player:, change:, match_id:)
      match = Match.find(match_id)
      ScoreChange.create!(match: match, player: player, change: change)
      match
    end
  end
end
