require 'sinatra'

require File.dirname(__FILE__) + '/lib/session'

get '/' do
	erb :index
end

post '/sessions' do
	session = Session.create(params)
	session.populate_sample_data
	redirect "/sessions/#{session.key}"
end

get '/sessions/:key' do
	@session = Session.filter(:key => params[:key]).first
	erb :session
end

