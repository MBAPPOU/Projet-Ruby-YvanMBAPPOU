class RackDebug

  def call(env)
    req = Rack::Request.new(env)
    req.session["history"] ||= []
    req.session["history"] << [req.request_method,req.path_info, req.query_string]
    res = Rack::Response.new
    res.write "cookie= #{req.cookies.inspect}</br>"
    res.write "rack.session.id=#{env["rack.session.id"]}</br>"
    res.write "rack.session=#{env["rack.session"].inspect}</br>"
    res.finish
  end

end

