class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @user = User.new(user_params)
	  if @user.save
	      token = JsonWebToken.encode(user_id: @user.id)
	      session[:token] = token
	      render json: @user
	  else
	      render json: {message: "Somthing Wrong"}
	  end
  end

 def login
    @user = User.find_by(email: params[:email])

    if @user && @user.password == params[:password]
      token = JsonWebToken.encode(user_id: @user.id)
      session[:token] = token
      render json: { user: @user, token: token }
    else
      render json: { message: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
