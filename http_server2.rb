require 'socket'
require 'reponse'
require 'requete'

port = 8080 # port d'écoute du serveur
server = TCPServer.open(port)

class String

include Reponse
include Requete

  def self.random(size=20)
    set = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    (1..size).map{ set[rand(set.length)] }.join
  end
end

def generate_cookie
  require 'digest/md5'
    Digest::MD5.hexdigest("cooooookiiiie"+String.random)
end


trap('EXIT'){ server.close }
fork do
  trap('INT'){ exit }
  loop do
    socket = server.accept

    sessions = {}
   
    req = Requete.new(socket)
    [ first_line, headers , body ] = req.requete

    # response code
    socket.puts("200 HTTP/1.1 ok")
    # response headers
    response_body = [request, headers.inspect, body ].join("\n")
	
    if req.cookie? # Si Cookie dans la requete..
    	    name,val = req.cookie
	    if sessions[val]
	    tmp = sessions[val]
	    tmp["nbvisites"] +=1
	    response_body = [response_body,"", tmp["nbvisites"]].join("\n")
	    else
	    end
    else #  Si pas de cookie dans la requete...
    session_id = generate_cookie
    sessions[session_id] = {"nbvisites" => 0}
    tmp = sessions[session_id]
    response_body = [response_body, "" ,tmp["nbvisites"]].join("\n")
    socket.puts ("Set-Cookie: session_id=#{session_id};expires=Fri, 17-Feb-2012 23:59:00;path=/;domain=/")
    end

    socket.puts ("Content-Length: #{response_body.length}")
    socket.puts("Content-Type: text/plain")
    
    socket.puts
    # response body
    socket.write response_body

    
    socket.close
  end
  exit
end

trap('INT') { puts "\nexiting" ; exit }

# Sit back and wait for all child processes to exit.
Process.waitall
