require 'socket'

port = 8080 # port d'écoute du serveur
server = TCPServer.open(port)

class String
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

    # request parsing
    request = socket.gets
    headers = {}
    sessions = {}
    begin
      header = socket.gets # On lit sur le socket la 1 ère ligne de la requête
      header_name, header_val = header.chomp.split(': ')
      headers[header_name] = header_val
    end until header.chomp.empty?

    body = nil
    unless headers["Content-Length"].nil? # on teste si le headers a un content-Length
      body = socket.read(headers["Content-Length"].to_i) # on lit et on stocke le corps de la requête
      socket.puts body
    end
    #puts "request = #{request}"
    #puts "headers = #{headers.inspect}"
    #puts "body = #{body}"

    # response code
    socket.puts("HTTP/1.1 200 OK")
    # response headers
    response_body = [request, headers.inspect, body ].join("\n")
	
    if headers["Cookie"] # Si Cookie dans la requete..
    	    champ1,champ2,champ3,champ4 = headers["Cookie"].chomp.split(';')
            name,val = champ1.split('=')
	    if sessions[val]
		    tmp = sessions[val]
		    tmp["nbvisites"] = tmp["nbvisites"] + 1
		    response_body = [response_body,"", tmp["nbvisites"]].join("\n")
		    socket.puts ("Connection: alive")
		    socket.puts ("Content-Length: #{response_body.length}")
		    socket.puts("Content-Type: text")
	    else
	    end
    else #  Si pas de cookie dans la requete...
    session_id = generate_cookie
    sessions[session_id] = {"nbvisites" => 0}
    tmp = sessions[session_id]
    response_body = [response_body, "" ,tmp["nbvisites"]].join("\n")
    socket.puts ("Connection: close")
    socket.puts ("Content-Length: #{response_body.length}")
    socket.puts("Content-Type: text/plain")
    socket.puts ("Set-Cookie: session_id=#{session_id}; expires=Fri, 17-Feb-2012 23:59:00 GMT; path=/; domain=/")
    end

    
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
