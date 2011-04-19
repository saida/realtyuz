class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :role_id, :account_id, :null => false 

      t.timestamps
    end
        
    Role.create(:name => 'administrator')
    account = Account.new
    account.login = "admin"
    account.email = "saida.temirkhodjaeva@gmail.com"
    account.password = "admin"
    account.password_confirmation = "admin"
    account.save(false)
    account.send(:activate!)
    role = Role.find_by_name('administrator')
    account = Account.find_by_login('admin')
    permission = Permission.new
    permission.role = role
    permission.account = account
    permission.save(false)
  end

  def self.down
    drop_table :permissions
    Role.find_by_name('administrator').destroy      
    Account.find_by_login('admin').destroy
  end
end
