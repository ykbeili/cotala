class AddTourIdToImage < ActiveRecord::Migration[6.1]
  def change
    add_reference :images, :tour, null: false, foreign_key: true
  end
end
