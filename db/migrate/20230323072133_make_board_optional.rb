class MakeBoardOptional < ActiveRecord::Migration[7.0]
  def change
    remove_reference :pins, :board
    add_reference :pins, :board, null: true, foreign_key: true
  end
end
