class CreateTours < ActiveRecord::Migration[6.1]
  def change
    create_table :tours do |t|
      t.string :agent_name

      t.timestamps
    end
  end
end
