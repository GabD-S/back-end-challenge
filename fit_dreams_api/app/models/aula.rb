class Aula < ApplicationRecord
  belongs_to :category

  has_many :enrollments, dependent: :destroy
  has_many :alunos, through: :enrollments, source: :user

  validates :name, :start_time, :duration, :teacher_name, :category, presence: true
  validates :duration, numericality: { only_integer: true, greater_than: 0 }
end
