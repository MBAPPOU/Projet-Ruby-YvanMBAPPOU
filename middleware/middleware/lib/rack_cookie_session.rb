class RackCookieSession

  def initialize(app,env_session_id_key="rack.session.id",cookie_name="session_id")
    @app = app
    @env_session_id_key = env_session_id_key
    @cookie_name = cookie_name
  end

  def call(env)
    # new session or not
    session_id = extract_session_id(env)
    if session_id # if not : extract_session_id
    	new_session = true
    else # if new : generate session_id
	    new_session = false
	    session_id = generate_session_id
            # store session id into env with the key env_session_id_key
	    env[@env_session_id_key] = session_id
    end

   # set cookie in headers if necessary
    status, headers, body = @app.call(env)
    res = Rack::Response.new(body,status,headers)
    res.set_cookie(@cookie_name,session_id) if new_session
    [status, headers, body]
  end

  def extract_session_id(env)
    req = Rack::Request.new(env)
    # get session id from cookie named @cookie_name
    req.cookies[@cookie_name]
  end

  def generate_session_id(bit_size=32)
    rand(2**bit_size - 1)
  end

end
    

