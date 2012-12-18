source :rubygems

gem 'sinatra', :require => 'sinatra/base'
gem "coffee-script"
gem "data_mapper"
gem "haml"
gem "json"
gem "redcarpet", "~> 2.2.2"

group :production do
  gem "pg"
  gem "dm-postgres-adapter"
end

group :development, :test do
  gem "dm-sqlite-adapter"
end
