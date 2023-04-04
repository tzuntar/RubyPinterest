class CreateJoinTablePinsTags < ActiveRecord::Migration[7.0]
  def change
    create_join_table :pins, :tags do |t|
      t.index [:pin_id, :tag_id]
      t.index [:tag_id, :pin_id]
    end
    add_foreign_key :pins_tags, :pins
    add_foreign_key :pins_tags, :tags
  end
end
