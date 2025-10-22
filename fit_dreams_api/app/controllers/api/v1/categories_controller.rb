module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :authenticate_request!
      before_action :set_category, only: [ :show, :update, :destroy ]

      def index
        categories = policy_scope(Category)
        render json: categories
      end

      def show
        authorize @category
        render json: @category
      end

      def create
        category = Category.new(category_params)
        authorize category
        if category.save
          render json: category, status: :created
        else
          render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @category
        if @category.update(category_params)
          render json: @category
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
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
