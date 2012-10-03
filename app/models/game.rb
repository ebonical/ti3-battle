class Game
  include DataMapper::Resource

  property :id, Serial
  property :token, String
  property :name, String
  property :created_at, DateTime

  has n, :players

  before :create, :set_token

  def self.generate_token(n = 8)
    chars = ('a'..'z').to_a
    n.times.map { chars[Random.rand(chars.size)]  }.join
  end

  def players_attributes=(player_array = [])
    player_array.each do |k, player_attributes|
      players << Player.new(player_attributes)
    end
  end

  def to_json(*args)
    attributes.merge(players: players).to_json(*args)
  end

  private

  def set_token
    begin
      self.token = self.class.generate_token
    end while Game.first(token: token)
  end
end
