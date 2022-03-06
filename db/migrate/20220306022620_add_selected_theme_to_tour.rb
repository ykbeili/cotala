class AddSelectedThemeToTour < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :selectedTheme, :boolean
  end
end
