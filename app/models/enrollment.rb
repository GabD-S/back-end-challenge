class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :aula

  validates :user_id, uniqueness: { scope: :aula_id }
end
