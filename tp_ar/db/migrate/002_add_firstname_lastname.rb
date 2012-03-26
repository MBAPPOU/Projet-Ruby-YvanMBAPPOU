class AddFirstnameLastname < ActiveRecord::Migration
  def up
    add_column :people,:last_name,:string
    add_column :people,:first_name,:string
  end

  def down
    remove_column :people,:last_name,:string
    remove_column :people,:first_name,:string
  end
  
end
