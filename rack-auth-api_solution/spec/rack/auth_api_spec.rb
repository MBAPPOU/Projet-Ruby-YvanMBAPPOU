require 'spec_helper'

describe AuthApi do 

 
  class User
    def self.find(*args)
    end
  end
  def app 
    auth_options = {:user_model => User, :find_method => :find}
    app = Rack::Builder.app do
      use AuthApi, auth_options
      run lambda{|env| [404, {'env' => env}, ["HELLO!"]]}
    end
  end

  subject { AuthApi.new(lambda{|env| [404, {'env' => env}, ["HELLO!"]]}, 
                        {:user_model => User, :find_method => :find})}

  # spécification d'initialisation
  it "should initialize  user_model to the given option" do 
    subject.user_model.should == User
  end

  # idem pour find_method, sans accesseur 
  # on teste directement si la variable d'instance est définie
  it "should initialize  find_method to the given option" do 
    subject.instance_variable_defined?(:@find_method).should be_true
  end

  context "decode_http_authorize" do
    it "should extract login and pass" do
      AuthApi.decode_http_authorize("dG90bzoxMjM0\n").should == ['toto', '1234']
    end
  end


  # cas 1 : pas de HTTP_AUTHORIZE
  context "when no HTTP_AUTHORIZE header" do
    it "should do nothing" do
      get '/'
      last_response.status.should == 404
    end
  
  end

    # cas 2 : HTTP_AUTHORIZE present
  context "when HTTP_AUTHORIZE header is present" do 
    before(:all) do
     basic_authorize 'toto', '1234'
    end

    it "should decode the login and the password" do 
      AuthApi.should_receive(:decode_http_authorize).with(["toto:1234"].pack('m'))
      get '/'
    end

    it "should delete the authorize header" do
      get '/'
      last_request.env['HTTP_AUTHORIZATION'].should be_nil
    end

    it "should check if toto:1234 if known to User.find" do
      User.should_receive(:find).with('1234')
      get '/'
    end
    context "a user matching the identifiers is found" do
      before do 
        User.stub(:find){ { :uid => "toto", :infos => { :name => "toto" }}}
      end

      it "should store the hash returned by the User class in rack environment under rack.auth.api key" do 
        get '/'
        last_request.env['rack.auth.api'].should == { :uid => "toto", :infos => { :name => "toto" }}
      end
    end

    context "no user is found" do 
      before do 
        User.stub(:find) { nil }
      end

      it "should not store anything under rack.auth.api in the rack environment" do 
        get '/'
        last_request.env['rack.auth.api'].should be_nil
      end
    end

     
  end
end
