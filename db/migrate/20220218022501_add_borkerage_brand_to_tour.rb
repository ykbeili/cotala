class AddBorkerageBrandToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :brokerage_brand, :string
  end
end
