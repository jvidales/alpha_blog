class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :edit, :destroy]
    before_action :require_user, only: [:edit, :update, :destroy]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    def new
        @user = User.new
    end

    def index
        @users = User.paginate(page: params[:page], per_page: 5)
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "Welcome, #{@user.username} You are now a member of our community"
            redirect_to @user
        else
            render 'new'
        end
    end

    def edit
        
    end

    def update
        if @user.update(user_params)
            flash[:notice] = "Account has been updated"
            redirect_to @user
        else
            render 'edit'
        end
    end

    def show
        @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end

    def destroy
        @user.destroy
        if !current_user.admin?
            session[:user_id] = nil
            redirect_to root_path
        else
            redirect_to users_path
        end
        flash[:notice] = "Account and posts have been deleted"
    end

    private

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert] = "Not Authorized"
            redirect_to @user
        end
    end
end