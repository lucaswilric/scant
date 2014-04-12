class AddDropboxAccessTokenToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :dropbox_access_token
      t.string :dropbox_user_id
    end
  end
end
