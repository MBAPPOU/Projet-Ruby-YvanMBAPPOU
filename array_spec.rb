# fichier array_spec.rb

describe "Array#join" do

	before(:each) do
	@t = ["a","b","c"]
	end

	it "transform an Array into a String" do
	@t.join().should be_an String
	end

	context "when no argument" do
		it "should concatenate each element" do
		@t.join().should == "abc"
		end
	end

	context "when given argument" do
		it "should interweave the argument between each element" do
		@t.join("-").should == "a-b-c"
		end
	end

end




