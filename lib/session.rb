require 'sha1'
require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://development.sqlite3')

unless DB.table_exists? :sessions
	DB.create_table(:sessions) do
		primary_key :id
		text :database_url
		text :user
		text :app
		text :key
	end
end

class Session < Sequel::Model
	def before_create
		self.key = generate_key
	end

	def generate_key
		SHA1.sha1((Time.now.to_f % 99999).to_s + rand.to_s).to_s
	end

	def database
		@db ||= Sequel.connect(database_url)
	end

	def populate_sample_data
		return if database.table_exists? :sample_table

		database.create_table(:sample_table) { integer :value1; integer :value2 }
		database[:sample_table] << { :value1 => 1, :value2 => 2 }
		database[:sample_table] << { :value1 => 3, :value2 => 4 }

		database.create_table(:sample_table2) { integer :value3; integer :value4 }
		database[:sample_table2] << { :value3 => 100, :value4 => 200 }
	end
end
