class AddFieldToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :access_token, :text
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
