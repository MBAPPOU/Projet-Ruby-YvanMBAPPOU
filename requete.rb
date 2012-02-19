module Requete
require 'socket'

attr_reader :socket , :request , :headers, :body

	def initialize(socket)
	@socket = socket
	self.read
	end

	def self.read
	    # request parsing
	    @request = @socket.gets  # On lit sur le socket la 1 ère ligne de la requête
	    headers = {}
	    begin
	      header = @socket.gets 
	      header_name, header_val = header.chomp.split(': ')
	      @headers[header_name] = header_val
	    end until header.chomp.empty?

	    @body = nil
	    unless headers["Content-Length"].nil? # on teste si le headers a un content-Length
	      @body = @socket.read(headers["Content-Length"].to_i) # on lit et on stocke le corps de la requête
	    end
	    [@request, @headers, @body]
	end

	def self.cookie?
	    @headers["Cookie"].nil?
	end

	def self.cookie
		if self.cookie?
		    champ1,champ2,champ3,champ4 = @headers["Cookie"].chomp.split(';')
		    champ1.split("=")
		else
		end
	end

end
