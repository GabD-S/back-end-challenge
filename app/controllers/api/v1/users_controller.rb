module Api
  module V1
    class UsersController < ApplicationController
  # Autenticação obrigatória apenas para /me
  before_action :authenticate_request!, only: [ :me ]

      # GET /api/v1/me
      def me
        render_success({ id: current_user.id, name: current_user.name, email: current_user.email, role: current_user.role })
      end

      # POST /api/v1/signup
      def create
        user = User.new(signup_params)
        user.role ||= :aluno
        if user.save
          token = JsonWebToken.encode({ user_id: user.id })
          render_success({
            token: token,
            exp: 24.hours.from_now.to_i,
            user: { id: user.id, name: user.name, email: user.email, role: user.role }
          }, status: :created)
        else
          render_errors(user.errors.full_messages, status: :unprocessable_entity)
        end
      end

      private

      def signup_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
