class AddEvernoteFieldsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :evernote_access_token
    end
  end
end
