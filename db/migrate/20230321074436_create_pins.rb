class CreatePins < ActiveRecord::Migration[7.0]
  def change
    create_table :pins do |t|
      t.string :title
      t.string :url
      t.string :description

      t.timestamps
    end
  end
end
