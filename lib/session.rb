require 'sha1'

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
end
