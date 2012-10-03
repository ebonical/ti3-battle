settings = BattleBoard.settings
# Logger
if settings.environment == :development
  DataMapper::Logger.new($stdout, :debug)
end

# Defaults
DataMapper::Property::String.length(255)

# Initialise data map
# 'postgres://localhost/mydb'
database_path = ENV['DATABASE_URL'] || 'sqlite://' + File.join(settings.root, "db/#{settings.environment}.db")
DataMapper.setup(:default, database_path)

DataMapper.auto_upgrade!
