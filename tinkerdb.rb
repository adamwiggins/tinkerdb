require 'sinatra'

require File.dirname(__FILE__) + '/lib/session'

get '/' do
	erb :index
end

post '/sessions' do
	session = Session.create(params)
	redirect "/sessions/#{session.id}"
end

get '/sessions/:id' do
	@session = Session.find(params[:id])
	erb :session
end

