module HTTP
require 'socket'


class Request

attr_reader :socket ,:request , :headers, :body

	def initialize (socket)
		@socket = socket
		@headers = Hash.new
		if socket
			read
		end
	end

	# lit le socket et retourne la requete et les headers
	def read
		# request parsing
		@request = @socket.gets  # On lit sur le socket la 1 ère ligne de la requête
		begin
			header = @socket.gets 
			header_name, header_val = header.chomp.split(': ')
			@headers[header_name] = header_val
		end until header.chomp.empty?
		#@headers = headers

		@body = nil
		unless @headers["Content-Length"].nil? # on teste si le headers a un content-Length
			@body = @socket.read(@headers["Content-Length"].to_i) # on lit et on stocke le corps de la requête
		end
		[@request, @headers, @body]
	end

	def self.cookie?
		@headers["Cookie"].nil?
	end

	def self.cookie
		if self.cookie?
			@headers["Cookie"].chomp.split(';')[1].split('=')
		end
	end	       


	def headers
		@headers
	end

	def path
		@request.chomp.split(' ')[1]
	end
end


class Response

attr_reader :code, :code_message , :headers ,:body 

	def initialize
		@@version = "HTTP/1.1"
		@headers = Hash.new
	end

	def headers
		@headers
	end


	def code= (string)
		@code = string
	end

	def code_message= string
		@code_message = string
	end

	def self.write (string)
		@body = string
	end

	def self.to_s
		first_line = [@code , @version , @code_message].join(' ')
		t = []
		# parcourir le headers et  le mettre au format http
		@headers.each do |clef,val|
			t << [clef,val].join(': ')
		end
		t.join("\n")
		@finalresponse = [first_line,t,""].join("\n")
	end

end

end
