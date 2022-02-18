class AddCotalaTourIdToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :cotala_tour_id, :integer
  end
end
