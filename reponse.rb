module Reponse

	def initialize(code,defaultversion="HTTP/1.1",codemessage,body,cookie)
		@code = code
		@version = defauktversion
		@codemessage = codemessage
		@body = body
		@cookie = cookie
		@contentLength = "Content-Length: #{@\body.length}"
		@contentType = "Content-Type: text/plain"

		reponse = [@code,@version,@codemessage].join(" ")
		if @cookie.nil?
		header = [ @reponse , @contentLength , @contentType, "", @body].join("\n")
		else
		cookiehttp = [ "Set-Cookie: ", @cookie ,";expires=Fri, 17-Feb-2012 23:59:00;path=/;domain=/" ].join('')
		header = [ @reponse ,  cookiehttp , @contentLength , @contentType, "", @body].join("\n")
		end
		header
	end

end
