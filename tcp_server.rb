require 'socket'
port = 8080 # port d'écoute du socket
server = TCPServer.open(port) # Activateur du port d'écoute
process_number = 1
trap('EXIT'){ server.close }
process_number.times do
	fork do
	trap('INT'){ exit }
		loop do
			socket = server.accept

			

			#name,val = "_______:_______".split(':')
			#headers[name] = val

			first_line = socket.gets.chomp  #lit une ligne entière
			type,url,version = first_line.split(" ")
			headers = Hash.new
			first_line = socket.gets.chomp

			while (first_line != "") do
	
			name,val = first_line.split(":")
			headers[name] = val
			first_line = socket.gets.chomp
			end



			# Reponse du serveur
			socket.puts "200 HTTP/1.0 ok"
			#socket.puts "Content-length : #{body.length}"
			socket.puts

			headers.each do |name, value|
				socket.puts "#{name} => #{value}"
			end

			socket.close

			# sockets.read(n) : lit n octets
			# socket.write string : écrit
			# socket.puts string : idem plus retour ligne
			#
			#request parsing
			#response code
			#response headers
			#response body
		end
	exit
	end
end
trap('INT') { puts "\nexiting" ; exit }
# on attend la fin des fils
Process.waitall

