class CategoriesController < ApplicationController
    before_action :require_admin, except: [:index, :show]

    def show
        @category = Category.find(params[:id])
        @category_articles = @category.articles.paginate(page: params[:page], per_page: 5)
    end

    def index
        @categories = Category.paginate(page: params[:page], per_page: 5)
    end

    def new
        @category = Category.new
    end

    def create
        @category = Category.new(category_params)
        if @category.save
            flash[:notice] = "Category successfully created"
            redirect_to @category
        else
            render 'new'
        end
    end

    def edit
        @category = Category.find(params[:id])
    end

    def update
        @category = Category.find(params[:id])
        if @category.update(category_params)
            flash[:notice] = "Category Updated Succesfully"
            redirect_to @category
        else
            render 'edit'
        end
    end

    private

    def category_params
        params.require(:category).permit(:name)
    end

    def require_admin
        if !(logged_in? && current_user.admin?)
            flash[:alert] = "Not enought permissions"
            redirect_to categories_path
        end
    end

end