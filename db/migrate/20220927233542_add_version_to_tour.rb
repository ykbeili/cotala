class AddVersionToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :version, :integer
  end
end
