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
  sessions = {}
  loop do
    socket = server.accept

    # request parsing
    request = socket.gets
    headers = {}

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

    # response code
    socket.puts("HTTP/1.1 200 OK")
    # response headers
    response_body = [request, headers.inspect, body ].join("\n")
	
    if headers["Cookie"] # Si Cookie dans la requete..
            val = headers["Cookie"].split('=')[0]
	    if sessions[val]
		    sessions[val][:nb] += 1
		    response_body = [response_body, ["Nombre de passages en mode session :", sessions[val][:nb]].join(' ') ].join("\n")
	    end
    else #  Si pas de cookie dans la requete...
	    session_id = generate_cookie
	    sessions[session_id] = {:nb => 0}
	    response_body = [response_body, ["Nombre de passages en mode session :" , sessions[session_id][:nb]].join('') ].join("\n")
	    socket.puts ("Content-Length: #{response_body.length}")
	    socket.puts ("Content-Type: text/plain")
	    socket.puts ("Set-Cookie: session_id=#{session_id}")
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
