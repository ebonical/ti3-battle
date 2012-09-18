class BattleBoard < Sinatra::Base
  get "/" do
    "Hello."
  end

  get "/javascripts/*" do
    begin
      filename = "/javascripts/"
      filename << params[:splat].join('/').sub(/\.js$/i, "")
      coffee filename.to_sym
    rescue Exception => e
      %{// #{e}}
    end
  end
end
