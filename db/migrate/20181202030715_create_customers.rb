class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.text :address
      t.string :zip_code
      t.string :city
      t.string :country_code

      t.timestamps
    end
  end
end
