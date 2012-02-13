module Password
  require 'digest/sha1'

  attr_reader :password

  def password=(clear_text)
    @password = Digest::SHA1.hexdigest(clear_text)
  end

  def authenticate(clear_text)
    Digest::SHA1.hexdigest(clear_text) == password
  end 
end
