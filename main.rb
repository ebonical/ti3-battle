class BattleBoard < Sinatra::Base
  load "db/config.rb"
  Dir['./app/models/**/*.rb'].each { |file| require file }
  Dir['./helpers/*.rb'].each { |file| require file }
  Dir['./lib/*.rb'].each { |file| require file }
  DataMapper.finalize

  helpers do
    include ApplicationHelper
  end

  get "/" do
    haml :index
  end

  get "/g/:token" do
    @game = Game.first(token: params[:token])
    haml :index
  end

  get "/g/:token.json" do
    content_type :json
    @game = Game.first(token: params[:token])
    @game.to_json
  end

  # Create a new game
  post "/games" do
    content_type :json
    @game = Game.new(params[:game])
    { success: @game.save, game: @game }.to_json
  end

  get "/javascripts/*" do
    begin
      if params[:splat].last == "all.js"
        coffee bundled_javascripts
      elsif params[:splat].last == "all.coffee"
        # Output raw coffee
        bundled_javascripts
      else
        file = params[:splat].pop.sub(/\.js$/i, "")
        path = File.join("javascripts", params[:splat], file)
        coffee path.to_sym, views: "assets"
      end
    rescue Exception => e
      %{console.error("#{e}")}
    end
  end


  private

  def bundled_javascripts
    out = []
    config = nil
    application = nil
    Dir[settings.root + "/assets/javascripts/**/*.coffee"].each do |file|
      src = File.read(file)
      case file
        when /application\.coffee$/ then application = src
        when /config\.coffee$/ then config = src
        else out << src
      end
    end
    config + out.join("\n") + application
  end
end
