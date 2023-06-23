import Config

config :starwars_api, port: 8081
config :starwars_api, database: "starwars"
config :starwars_api, pool_size: 3

config :starwars_api,
       :database_url,
       System.get_env("DATABASE_URL", "mongodb://localhost:27017/starwars")
