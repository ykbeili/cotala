class AddBrokerLogoToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :broker_logo, :string
  end
end
