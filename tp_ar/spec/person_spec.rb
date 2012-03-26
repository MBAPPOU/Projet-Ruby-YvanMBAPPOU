require_relative 'spec_helper'
require 'person'

describe Person do

   

        context "invalid" do
        
           it "should not have any last name and any first name" do
              Person.new.valid?.should be_false
           end
        
        end

        context "valid" do
        
           subject { p = Person.new;p.last_name = "MBAPPOU";p.first_name = "Yvan";p.save;p}
           
           it "should have a last name" do
              subject.last_name.should be "MBAPPOU"
           end
           
           it "should have a first name" do
              subject.first_name.should be "Yvan"
           end
           
           it "should be unique in database" do
              
           end
        end
end
