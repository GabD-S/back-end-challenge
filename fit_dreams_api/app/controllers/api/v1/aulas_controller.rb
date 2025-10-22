module Api
  module V1
    class AulasController < ApplicationController
      before_action :authenticate_request!
      before_action :set_aula, only: [ :show, :enroll ]

      def index
        aulas = policy_scope(Aula)
        render json: aulas
      end

      def show
        authorize @aula
        render json: @aula
      end

      def create
        aula = Aula.new(aula_params)
        authorize aula
        if aula.save
          render json: aula, status: :created
        else
          render json: { errors: aula.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def enroll
        authorize @aula, :enroll?
        enrollment = Enrollment.new(user: current_user, aula: @aula)
        if enrollment.save
          render json: { message: "Enrolled successfully", id: enrollment.id }, status: :created
        else
          render json: { errors: enrollment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_aula
        @aula = Aula.find(params[:id])
      end

      def aula_params
        params.require(:aula).permit(:name, :start_time, :duration, :teacher_name, :description, :category_id)
      end
    end
  end
end
