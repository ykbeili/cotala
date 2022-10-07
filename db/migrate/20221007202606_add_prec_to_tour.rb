class AddPrecToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :prec, :boolean
  end
end
