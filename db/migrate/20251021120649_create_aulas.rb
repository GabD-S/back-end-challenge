class CreateAulas < ActiveRecord::Migration[7.2]
  def change
    create_table :aulas do |t|
      t.string :name, null: false
      t.datetime :start_time, null: false
      t.integer :duration, null: false
      t.string :teacher_name, null: false
      t.text :description
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :aulas, :start_time
  end
end
