class AddUniqueIndexOnLowerEmailToUsers < ActiveRecord::Migration[7.2]
  def change
    # Remove existing unique index on email if present
    remove_index :users, :email if index_exists?(:users, :email)

    # Add expression index on lower(email) for case-insensitive uniqueness
    add_index :users, 'LOWER(email)', unique: true, name: 'index_users_on_lower_email'
  end
end
