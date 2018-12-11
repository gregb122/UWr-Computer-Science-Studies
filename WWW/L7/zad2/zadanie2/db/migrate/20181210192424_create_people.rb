class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :name
      t.string :surname
      t.integer :age
      t.integer :height

      t.timestamps
    end
  end
end
