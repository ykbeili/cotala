class AddSelectedImagesToTours < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :selected_images, :text, default: [].to_yaml
  end
end
