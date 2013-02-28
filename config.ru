# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

map "/manifest" do
  run lambda do |env|
    manifest = File.read("./public/manifest.appcache")
    [200, {"Content-Type" => "text/cache-manifest"}, [manifest]]
  end
end

map "/" do
  run Fresh::Application
end
