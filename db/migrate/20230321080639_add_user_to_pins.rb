class AddUserToPins < ActiveRecord::Migration[7.0]
  def change
    add_reference :pins, :user, null: false, foreign_key: true
  end
end
