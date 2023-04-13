class CreateJoinTableBordsPins < ActiveRecord::Migration[7.0]
  def change

    create_join_table :boards, :pins do |t|
      t.index [:board_id, :pin_id]
      t.index [:pin_id, :board_id]
    end
    add_foreign_key :boards_pins, :boards
    add_foreign_key :boards_pins, :pins
    remove_column :pins, :board_id
  end
end
