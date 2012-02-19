$:.unshift File.join(File.dirname(__FILE__), '..')
require 'requete'
require 'socket'

class UneRequete
include Requete
end

describe UneRequete do

	context "when initializing" do
		it "should receive a socket" do
		subject {req = Requete.new(socket)}
		subject.socket should_not be nil
		end
		
		it "should apply method << read >> for reading in the socket and return request,headers and body  in http form" do
		request = "GET / HTTP/1.1"
		headers = {"Host"=>"localhost:8080", "User-Agent"=>"Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:10.0.2) Gecko/20100101 Firefox/10.0.2", "Accept"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Accept-Language"=>"fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3", "Accept-Encoding"=>"gzip, deflate", "Connection"=>"keep-alive", nil=>nil}
		body = "Nombre de visites = 0"
		subject { double(Requete) }
		subject.stub(:read).and_return([request, headers, body])
		subject.should_apply(:read).and_return([request, headers, body])
		subject.new(socket)
		end
	end

end
