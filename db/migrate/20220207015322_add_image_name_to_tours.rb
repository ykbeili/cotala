class AddImageNameToTours < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :image_name, :string
  end
end
