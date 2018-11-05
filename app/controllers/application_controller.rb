class ApplicationController < ActionController::API
  def render_errors(status,errors)
    render json: {errors: errors }, status: status
  end
end
