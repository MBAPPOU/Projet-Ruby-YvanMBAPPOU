require 'spec_helper'

class User
  @@list = {}
  
  def self.find(key)
     @@list[key.to_Sym]
  end

  def self.add(key,val)
     @@list[key.to_sym] = val
  end

end

describe AuthApi do
 
  # Initialisation du middleware à tester
  def app 
      auth_options = {:user_model => User, :find_method => :find}
      app = Rack::Builder.app do
      use AuthApi, auth_options
      run lambda{|env| [404, {'env' => env}, ["HELLO!"]]}
      end
  end

  subject { AuthApi.new(lambda{|env| [404, {'env' => env}, ["HELLO!"]]}, 
                        {:user_model => User, :find_method => :find})}
                        
  
  # Specification d'initialisation
  it "should store initialize user_model to the given option"  do
     subject.user_model.should be User
  end
  
  it "should find method to apply on this user_model" do
     subject.find_method.should be :find
  end     
                        
  #Cas 1: pas de HTTP_AUTHORIZE 
  context "when no HTTP_AUTHORIZE in header" do
     it "should do nothing" do
     get '/'
     last_response.status.should == 404
     end
  end
  
  specify "decode_http_authorize" do
     AuthApi.decode_http_authorize(["agent:007"].pack('m')).should == ["agent:007"]
  end
  
  #Cas 2: HTTP_AUTHORIZE
   context "when HTTP_AUTHORIZE in header" do
   
        before(:all) do
           # Ajout dans les headers de 'env' un http_authorization avec pour valeur de login et mdp "toto" et "1234"
           basic_authorize "toto","1234"
        end
   
        it "should decode login and password" do
           AuthApi.should_receive(:decode_http_authorize).with(["toto:1234"].pack('m'))
           get '/'
        end
        
        it "decode_http_authorize" do
           AuthApi.decode_http_authorize(["toto:1234"].pack('m')).should == ["toto:1234"]
        end
        
        it "should delete the authorize header" do
        get '/'
           last_request.env['HTTP_AUTHORIZATION'].should be_nil
        end
        
        it "should check if toto:1234 known to User.find (in this case, condition is false)" do
        get '/'
           last_request.env["rack.api.user"].should be_nil
        end
        
        it "should check if toto:1234 known to User.find (in this case, condition is true)" do
           User.add("1234","toto")
           get '/'
           last_request.env["rack.api.user"].should_not be_nil
        end
        
  end

end
