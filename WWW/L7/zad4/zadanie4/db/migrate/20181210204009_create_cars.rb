class CreateCars < ActiveRecord::Migration[5.2]
  def change
    create_table :cars do |t|
      t.string :reg_number
      t.string :date_of_first_registration
      t.string :car_brand
      t.integer :production_year
      t.string :fuel_category

      t.timestamps
    end
  end
end
