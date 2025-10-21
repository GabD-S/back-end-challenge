class User < ApplicationRecord
	has_secure_password

		enum :role, { aluno: 0, professor: 1, admin: 2 }

	has_many :enrollments, dependent: :destroy
	has_many :aulas, through: :enrollments

	validates :name, presence: true
	validates :email, presence: true, uniqueness: true
end
