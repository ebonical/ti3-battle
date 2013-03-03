class Game < ActiveRecord::Base
  has_many :players, order: "number"

  before_create :set_token

  attr_accessible :name,
                  :players_attributes

  def self.generate_token(n = 8)
    chars = ('a'..'z').to_a
    n.times.map { chars[Random.rand(chars.size)]  }.join
  end

  def players_attributes=(player_array = [])
    player_array.each do |k, player_attributes|
      players.build player_attributes
    end
  end

  def as_json(*)
    attributes.merge(players: players)
  end

  private

  def set_token
    begin
      self.token = self.class.generate_token
    end while Game.find_by_token(token)
  end
end
