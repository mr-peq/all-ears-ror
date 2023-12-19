class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.integer :number_of_rounds

      t.timestamps
    end
  end
end
