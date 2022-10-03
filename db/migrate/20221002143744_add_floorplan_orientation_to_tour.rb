class AddFloorplanOrientationToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :floorplan_orientation, :string
  end
end
