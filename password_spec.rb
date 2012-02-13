$:.unshift File.join(File.dirname(__FILE__), '..')
require 'Password'

class DummyClassWithPasswordModule
  include Password
end

describe DummyClassWithPasswordModule do 
   it "should encrypt the password with sha1" do
    Digest::SHA1.should_receive(:hexdigest).with("foo").and_return("0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33")
    subject.password="foo"
  end

  it "should store she sha1 digest" do
    subject.password="foo"
    subject.password.should == "0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"
  end

  describe "user authentication"  do 
    it "should crypt the clear password given" do 
      Digest::SHA1.should_receive(:hexdigest).with("foo").and_return("0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33")
      subject.authenticate("foo")
    end

    describe "authentication with password challenge" do
      subject{ p = DummyClassWithPasswordModule.new; p.password = "foo"; p}
      context "correct password" do
        it "should return valid authentication" do 
          subject.authenticate("foo").should be_true
        end
      end

      context "incorrect password" do
        it "should return invalid authentication" do
          subject.authenticate("bad pass").should be_false
        end
      end
    end
  end
end 
