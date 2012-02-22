require 'socket'
$:.unshift File.dirname(__FILE__)
require 'http'

class TestRequest
include HTTP
end

class TestResponse
include HTTP
end

describe TestRequest do 

	before(:each) do
		@socket = double(Socket)
		@socket.stub(:gets).and_return("GET / HTTP/1.1","Host: localhost:8080","User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:10.0.2) Gecko/20100101 Firefox/10.0.2", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Accept-Language: fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3", "Accept-Encoding : gzip, deflate", "Connection: keep-alive", "nil: nil")
		@req = HTTP::Request.new(@socket)
	end

	context "when initializing" do
		it "should receive a socket" do
			@req.socket.should_not be nil
			@req.socket.should be_an Socket
		end

		it "should return the request's path " do
			@req.path.should be "/"
		end
		
		it "should return the request's headers " do
			@req.headers.inspect.should be_an Hash
		end
	end

end

describe TestResponse do


	before(:each) do
		@res = HTTP::Response.new
	end

	context "when initializing" do
		it "should return an empty header" do
			@res.headers.should be nil
		end

		it "should return an empty code" do
			@res.code.should be nil
		end

		it "should return an empty code message" do
			@res.code_message.should be nil
		end

		it "should return an empty body" do
			@res.body.should be nil
		end
	end

	context "after giving some arguments" do
		it "should generate a request in http form" do
			@res.headers["Content-Type"] = "text/plain"
			@res.headers["Content-Length"] = 22
			@res.code = 200
			@res.code_message = "OK"
			@res.write ("Nombre de visites: 5 !") 
			@res.to_s.should_be "200 HTTP/1.1 OK\nContent-Type: text/plain\nContent-Length: 22\n\nNombre de visites: 5 !"
		end
	end

end
