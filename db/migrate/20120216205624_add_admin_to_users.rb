class AddAdminToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false #without the :default value it will be nil,
                                                            #and that is still false
  end

  def self.down
    remove_column :users, :admin
  end
end
