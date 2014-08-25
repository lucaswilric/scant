class AddQualityToDocument < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.string :quality
    end
  end
end
