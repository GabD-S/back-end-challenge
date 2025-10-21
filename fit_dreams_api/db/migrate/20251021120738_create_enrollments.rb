class CreateEnrollments < ActiveRecord::Migration[7.2]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :aula, null: false, foreign_key: true

      t.timestamps
    end
    add_index :enrollments, [:user_id, :aula_id], unique: true
  end
end
