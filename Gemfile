source :rubygems

gem 'sinatra', :require => 'sinatra/base'
gem "coffee-script"
gem "haml"
gem "data_mapper"
gem "json"

group :production do
  gem "pg"
  gem "dm-postgres-adapter"
end

group :development, :test do
  gem "dm-sqlite-adapter"
end
