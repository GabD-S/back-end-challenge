module Api
  module V1
    class AuthenticationController < ApplicationController
      # POST /api/v1/login
      # Params: { email: String, password: String }
      def create
        email = params.require(:email).to_s.strip.downcase
        password = params.require(:password).to_s

        user = User.find_by("LOWER(email) = ?", email)

        if user&.authenticate(password)
          token = JsonWebToken.encode({ user_id: user.id })
          render_success({
            token: token,
            exp: 24.hours.from_now.to_i,
            user: { id: user.id, name: user.name, email: user.email, role: user.role }
          })
        else
          render_errors([ "Invalid email or password" ], status: :unauthorized)
        end
      end
    end
  end
end
