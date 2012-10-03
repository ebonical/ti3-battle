class Player
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :number, Integer
  property :color, String
  property :race, String
  property :technologies, Text
  property :created_at, DateTime
  belongs_to :game

  def to_s
    name
  end
end
