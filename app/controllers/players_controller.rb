class PlayersController < ApplicationController
  def update
    @player = Player.find(params[:id])
    @player.update_attributes params[:player]
    render json: @player
  end
end
