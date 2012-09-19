class BattleBoard < Sinatra::Base
  Dir['./helpers/*.rb'].each { |file| require file }
  Dir['./lib/*.rb'].each { |file| require file }

  helpers do
    include ApplicationHelper
  end

  get "/" do
    haml :index
  end

  get "/javascripts/*" do
    begin
      filename = "/javascripts/"
      filename << params[:splat].join('/').sub(/\.js$/i, "")
      coffee filename.to_sym
    rescue Exception => e
      %{console.error("#{e}")}
    end
  end
end
