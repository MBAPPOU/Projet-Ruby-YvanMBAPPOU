class RackSession
  attr_reader :pool

  def initialize(app)
    @app = app
    @pool = Hash.new
  end

  def call(env)
    load_session(env)
    status, headers, body = @app.call(env)
    commit_session(env)
    [status, headers, body]
  end

  def load_session(env)
    #Req = Rack::Request.new(env)
    env[rack.session] = @pool[env[env_session_id_key]]
    # load session in env["rack.session"]
  end

  def commit_session(env)
    @pool[env[env_session_id_key]] = env.cookie_name
    # save session into @pool
  end
end
