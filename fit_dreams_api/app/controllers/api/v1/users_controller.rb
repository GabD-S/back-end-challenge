module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_request!

      # GET /api/v1/me
      def me
        render_success({ id: current_user.id, name: current_user.name, email: current_user.email, role: current_user.role })
      end
    end
  end
end
