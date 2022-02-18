class AddColumnsToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :agent_phone, :string
    add_column :tours, :agent_email, :string
    add_column :tours, :agent_url, :string
    add_column :tours, :brokerage_name, :string
    add_column :tours, :brokerage_address, :string
    add_column :tours, :listing_address, :string
    add_column :tours, :show_price, :boolean
    add_column :tours, :price, :integer
    add_column :tours, :mls, :string
    add_column :tours, :tax, :string
    add_column :tours, :built, :integer
    add_column :tours, :bedrooms, :integer
    add_column :tours, :bathrooms, :integer
    add_column :tours, :size, :string
    add_column :tours, :lot_or_maint, :boolean
    add_column :tours, :lot_maint, :float
    add_column :tours, :description, :text
    add_column :tours, :style, :text
    add_column :tours, :property_type, :integer
    add_column :tours, :num_of_pics, :integer
    add_column :tours, :print_job_id, :integer
  end
end
