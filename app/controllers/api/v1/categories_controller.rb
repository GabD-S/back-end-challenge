module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :authenticate_request!
      before_action :set_category, only: [ :show, :update, :destroy ]

      def index
        categories = policy_scope(Category)
        page = params.fetch(:page, 1).to_i
        per_page = [[params.fetch(:per_page, 20).to_i, 100].min, 1].max
        total = categories.count
        total_pages = (total / per_page.to_f).ceil
        records = categories.offset((page - 1) * per_page).limit(per_page)

        render json: {
          data: records,
          meta: {
            pagination: { page: page, per_page: per_page, total: total, total_pages: total_pages }
          }
        }, status: :ok
      end

      def show
        authorize @category
        render_success(@category)
      end

      def create
        category = Category.new(category_params)
        authorize category
        if category.save
          render_success(category, status: :created)
        else
          render_errors(category.errors.full_messages, status: :unprocessable_entity)
        end
      end

      def update
        authorize @category
        if @category.update(category_params)
          render_success(@category)
        else
          render_errors(@category.errors.full_messages, status: :unprocessable_entity)
        end
      end

      def destroy
        authorize @category
        @category.destroy
        head :no_content
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description)
      end
    end
  end
end
