require 'sha1'
require 'sequel'

class Session
	def self.all
		@@all ||= {}
	end

	class RecordNotFound < RuntimeError; end

	def self.find(id)
		all[id] or raise RecordNotFound
	end

	def self.create(params)
		id = generate_id
		all[id] = new(params.merge(:id => id))
	end

	def self.generate_id
		SHA1.sha1((Time.now.to_f % 99999).to_s + rand.to_s).to_s
	end

	attr_accessor :id, :database_url, :user, :app

	def initialize(params)
		@id = params[:id]
		@database_url = params[:database_url] or raise(ArgumentError, "No database url provided")
		@user = params[:user]
		@app = params[:app]
	end

	def database
		@db ||= Sequel.connect(database_url)
	end

	def populate_sample_data
		database.create_table(:sample_table) { integer :value1; integer :value2 }
		database[:sample_table] << { :value1 => 1, :value2 => 2 }
		database[:sample_table] << { :value1 => 3, :value2 => 4 }

		database.create_table(:sample_table2) { integer :value3; integer :value4 }
		database[:sample_table2] << { :value3 => 100, :value4 => 200 }
	end
end
