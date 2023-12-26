class AddDeviceTokenInUsers < ActiveRecord::Migration[6.1]
  def change
     add_column :users, :device_token, :string
  end
end
