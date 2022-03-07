class AddMoreColumnsToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :first_image, :string
    add_column :tours, :second_image, :string
    add_column :tours, :third_image, :string
    add_column :tours, :fourth_image, :string
    add_column :tours, :fifth_image, :string
    add_column :tours, :sixth_image, :string
    add_column :tours, :seventh_image, :string
    add_column :tours, :eighth_image, :string
    add_column :tours, :ninth_image, :string
    add_column :tours, :tenth_image, :string
    add_column :tours, :eleventh_image, :string
    add_column :tours, :twelfth_image, :string
    add_column :tours, :thirteenth_image, :string
    add_column :tours, :fourteenth_image, :string
    add_column :tours, :fifteenth_image, :string
  end
end
