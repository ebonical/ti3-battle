class GamesController < ApplicationController
  def show
    @game = Game.find_by_token(params[:id])
    respond_to do |wants|
      wants.html { render action: :index }
      wants.json { render json: @game }
    end
  end

  def create
    @game = Game.new(params[:game])
    render json: { success: @game.save, game: @game }
  end

  def readme
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    output = markdown.render File.read(File.join(Rails.root, "Readme.md"))
    render inline: output
  end
end
