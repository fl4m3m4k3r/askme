class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

<<<<<<< HEAD
    @user.save
=======
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Вы успешно зарегистрированы!'
    else
      render 'new'
    end
>>>>>>> 0c37b7b... temp
  end

  def show
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :name, :username, :avatar_url)
  end
end
