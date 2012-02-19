$:.unshift File.join(File.dirname(__FILE__), '..')
require 'reponse'

class UneReponse
include Reponse
end

describe UneReponse do

	context " when initializing" do
		it "should receive 4 arguments" do
		end

		it "should return response in http form"
		subject { double(Reponse) }
		subject.new.should_return("200 HTTP/1.1 OK\nSet-Cookie: name=val;expires=Fri, 17-Feb-2012 23:59:00;path=/;domain=/\nContent-Length: 5\nContent-Type: text/plain\n\n\n alpha")
		subject.new(200,,"OK","alpha","name=val")
		end
	end

end
