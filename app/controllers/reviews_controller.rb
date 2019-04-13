class ReviewsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
  end

  def new
    @item = Item.find(params[:item_id])
    @review = Review.new
  end

  def create
    @item = Item.find(params[:item_id])
    @user = User.find(current_user.id)
    @review = @item.reviews.create(review_params)
    @review.user_id = @user.id
    # binding.pry
    if @review.save
      # redirect to root_path
      redirect_to user_reviews_path(current_user.id)
    else
      flash[:notice] = @review.errors.full_messages.join(", ")
      render :new
    end
# binding.pry
  end

private

  def review_params
    params.require(:review).permit(:title, :description, :rating)
  end
end
