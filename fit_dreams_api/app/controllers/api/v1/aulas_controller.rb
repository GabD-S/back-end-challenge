module Api
  module V1
    class AulasController < ApplicationController
      before_action :authenticate_request!
      before_action :set_aula, only: [ :show, :enroll, :update, :destroy ]

      def index
        aulas = policy_scope(Aula)
        render_success(aulas)
      end

      def show
        authorize @aula
        render_success(@aula)
      end

      def create
        aula = Aula.new(aula_params)
        authorize aula
        if aula.save
          render_success(aula, status: :created)
        else
          render_errors(aula.errors.full_messages, status: :unprocessable_entity)
        end
      end

      def enroll
        authorize @aula, :enroll?
        enrollment = Enrollment.new(user: current_user, aula: @aula)
        if enrollment.save
          render_success({ message: "Enrolled successfully", id: enrollment.id }, status: :created)
        else
          render_errors(enrollment.errors.full_messages, status: :unprocessable_entity)
        end
      end

      def update
        authorize @aula
        if @aula.update(aula_params)
          render_success(@aula)
        else
          render_errors(@aula.errors.full_messages, status: :unprocessable_entity)
        end
      end

      def destroy
        authorize @aula
        @aula.destroy
        head :no_content
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
