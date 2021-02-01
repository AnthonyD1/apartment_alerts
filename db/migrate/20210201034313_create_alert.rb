class CreateAlert < ActiveRecord::Migration[6.1]
  def change
    create_table :alerts do |t|
      t.string :city
      t.text :search_params

      t.timestamps
    end
  end
end
