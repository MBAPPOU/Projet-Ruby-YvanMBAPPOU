require 'sinatra'
$: << File.join(File.dirname(__FILE__),"","middleware")
require 'my_middleware'

use RackCookieSession
use RackSession

helpers do 
  def current_user
    session["current_user"]
  end

  def disconnect
    session["current_user"] = nil
  end
end


get '/test' do
   body "#{env["request"]}"
end

get '/' do
  if current_user
    "Bonjour #{current_user}"
  else
    '<a href="/sessions/new">Login</a>' # renvoie une page avec le lien vers sessions/new
  end
end

get '/sessions/new' do
  erb :"sessions/new"
end


post '/sessions' do
	#on lit les parametres de la requête
	parametres = params
	# Si authentification correcte, on redirige vers l'environnement protégé des users
	if parametres[login] == 'toto' and parametres[password] == 'toto'
		session["current_user"] = 'toto'
		redirect '/protected'
	else # Sinon on redirige vers la page d'authantification
		redirect '/sessions/new'
	end
end


get '/protected' do
	if current_user
		erb :'protected' , :locals => {:user => current_user}
	else
		redirect 'sessions/new'
	end
end
 

get '/sessions/id' do
	disconnect
	redirect '/'
end



