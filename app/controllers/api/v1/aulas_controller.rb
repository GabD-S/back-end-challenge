module Api
  module V1
    class AulasController < ApplicationController
      before_action :authenticate_request!
      before_action :set_aula, only: [ :show, :enroll, :update, :destroy ]

      def index
        scope = policy_scope(Aula)
        # Filters
        if params[:category_id].present?
          scope = scope.where(category_id: params[:category_id])
        end
        if params[:start_time_from].present?
          begin
            from = Time.parse(params[:start_time_from])
            scope = scope.where("start_time >= ?", from)
          rescue ArgumentError
            # ignore invalid date filter
          end
        end
        if params[:start_time_to].present?
          begin
            to = Time.parse(params[:start_time_to])
            scope = scope.where("start_time <= ?", to)
          rescue ArgumentError
            # ignore invalid date filter
          end
        end

        # Pagination
        page = params.fetch(:page, 1).to_i
        per_page = [[params.fetch(:per_page, 20).to_i, 100].min, 1].max
        total = scope.count
        total_pages = (total / per_page.to_f).ceil
        records = scope.offset((page - 1) * per_page).limit(per_page)

        render json: {
          data: records,
          meta: {
            pagination: { page: page, per_page: per_page, total: total, total_pages: total_pages }
          }
        }, status: :ok
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
