class AddSelectedThemeToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :selected_theme, :string
  end
end
