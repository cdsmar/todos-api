# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.all
    json_response(@users)
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    json_response(@user)
  end
end
