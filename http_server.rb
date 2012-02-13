require 'socket'

port = 8080
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
      header = socket.gets
      header_name, header_val = header.chomp.split(': ')
      headers[header_name] = header_val
    end until header.chomp.empty?

    body = nil
    unless headers["Content-Length"].nil? # on teste si le headers a un content-Length
      body = socket.read(headers["Content-Length"].to_i)
      socket.puts body
    end
    puts "request = #{request}"
    puts "headers = #{headers.inspect}"
    puts "body = #{body}"

    # response code
    socket.puts("200 HTTP/1.1 ok")
    # response headers
    response_body = [request, headers.inspect, body].join("\n")
	
    if headers["Cookie"].nil?
    tmp,id_session = headers["Cookie"].split('=')
    session[id_session] ["nbvisites"] += 1
    else
    socket.puts("Content-Length: #{response_body.length}")
    session_id = generate_cookie
    session[session_id] = "{nbvisites,0}"
    socket.puts ("Set-cookie: session_id=#{session_id};expires_date=;path=/;domain=.exemple.org")
    end

    socket.puts("Content-Length: #{response_body.length}")
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

