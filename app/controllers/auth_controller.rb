# app/controllers/auth_controller.rb
class AuthController < ApplicationController
  # POST /signup
  def signup
    user = User.create!(user_params)
    json_response(user, :created)
  end

  # POST /auth/login
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      json_response(user)
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # GET /auth/logout
  def logout
    session[:user_id] = nil
    head :no_content
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
