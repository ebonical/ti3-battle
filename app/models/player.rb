class Player < ActiveRecord::Base
  belongs_to :game

  attr_accessible :name,
                  :number,
                  :color,
                  :race,
                  :technologies

  #
  def to_s
    name
  end
end
