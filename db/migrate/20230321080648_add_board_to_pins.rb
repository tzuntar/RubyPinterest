class AddBoardToPins < ActiveRecord::Migration[7.0]
  def change
    add_reference :pins, :board, null: false, foreign_key: true
  end
end
