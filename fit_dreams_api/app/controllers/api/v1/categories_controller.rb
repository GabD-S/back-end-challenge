module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :authenticate_request!

      def index
        categories = policy_scope(Category)
        render json: categories
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

      private

      def category_params
        params.require(:category).permit(:name, :description)
      end
    end
  end
end
