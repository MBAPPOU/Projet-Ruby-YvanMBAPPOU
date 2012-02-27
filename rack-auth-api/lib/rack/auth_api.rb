class AuthApi
  
  def initialize( app, options = {} )
    @app = app
    @options = options
  end
  
  def call(env)
    
    if env['HTTP_AUTHORIZATION']
            b64 = env['HTTP_AUTHORIZATION'].gsub!(/Basic /, "")
            # Si le header HTTP_AUTHORIZATION est positionné, les identifiants passés par ce headers doivent être vérifiés par l'appel d'un code externe.
            if (AuthApi.decode_http_authorize(b64) != nil)
                    @uid = AuthApi.decode_http_authorize(b64).gsub!(/\n/,"" ).split(':')[0]
                    @mdp = AuthApi.decode_http_authorize(b64).gsub!(/\n/,"" ).split(':')[1]
            end
            # Le header HTTP_AUTHORIZATION est effacé dans tous les cas de 'env'.
            env.delete('HTTP_AUTHORIZATION')
    end
    # Si les identifiants sont corrects, la clef rack.api.user est positionnée à un Hash contenant un identifiant unique de l'utilisateur.
    if ( @mdp != nil )
       verification = [ @options[:user_model], ".", @options[:find_method].to_s , "(", @mdp , ")" ].join("")
    else
       verification = nil
    end
    
    if ( verification != nil && verification == @uid )
       env["rack.api.user"] = @uid
    end
    status, headers, body = @app.call(env)
    
  end
  
  
  def self.decode_http_authorize(string)
        string.unpack('m') if string != nil
  end
  
  def user_model
    @options[:user_model]
  end
  
  def find_method
    @options[:find_method]
  end
  
end
