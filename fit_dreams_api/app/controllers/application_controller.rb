class ApplicationController < ActionController::API
  attr_reader :current_user

  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from JWT::DecodeError, JWT::ExpiredSignature, with: :render_unauthorized
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  private

  # Before-action to protect endpoints
  def authenticate_request!
    token = bearer_token
    payload = JsonWebToken.decode(token)
    @current_user = User.find(payload["user_id"]) if payload["user_id"]
  rescue StandardError
    render_unauthorized
  end

  def bearer_token
    auth_header = request.headers["Authorization"]
    return nil if auth_header.blank?

    scheme, token = auth_header.split(" ", 2)
    return token if scheme&.casecmp("Bearer")&.zero?

    # Fallback: if header has only the token
    auth_header
  end

  def render_unauthorized
    render json: { errors: [ "Unauthorized" ] }, status: :unauthorized
  end

  def render_forbidden
    render json: { errors: [ "Forbidden" ] }, status: :forbidden
  end

  def render_not_found
    render json: { errors: [ "Not Found" ] }, status: :not_found
  end

  # Standard success wrapper
  def render_success(data, status: :ok)
    render json: { data: data }, status: status
  end

  # Standard error wrapper
  def render_errors(errors, status: :unprocessable_entity)
    payload = errors.is_a?(Array) ? errors : [ errors ]
    render json: { errors: payload }, status: status
  end
end
