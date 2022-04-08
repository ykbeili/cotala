class AddMultipleColumnsToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :agent_logo, :boolean
    add_column :tours, :agent_logo_url, :string
    add_column :tours, :agent_headshot, :boolean
    add_column :tours, :agent_headshot_url, :string
    add_column :tours, :hook_url, :string
  end
end
