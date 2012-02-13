$:.unshift File.join(File.dirname(__FILE__), '..')
# $: tableau contenant les répertoires où on cherche les fichiers en appelant require
# __FILE__ : le nom du fichier courant
# File.dirname(...) : le nom du répertoire hébergeant le fichier 
# File.join : construit un chemin d'accès à un fichier en concaténant les éléments passés

require 'person'
describe Person do
  context "when created" do
    its(:last_name) {should be_empty}
    its(:first_name) {should be_empty}
    its(:id) {should be_empty}
  end

  describe "validation" do
    before(:each) do
      @person = Person.new
      @person.last_name = "toto"
      @person.first_name = "titi"
      @person.id = "tata"
    end
    context "whith a first_name, a last_name and a id" do
      it "should be valid" do
        @person.should be_valid
      end
    end
    ["last_name", "first_name", "id"].each do |attr|
      context "without a #{attr}" do
        it "should not be valid" do
          @person.send("#{attr}=", nil)
          @person.should_not be_valid
        end
      end
      context "with an empty #{attr}" do
        it "should not be valid" do
          @person.send("#{attr}=", "")
          @person.should_not be_valid
        end
      end
    end
  end

  it "should include the password module" do
    Person.included_modules.should include(Password)
  end
end
