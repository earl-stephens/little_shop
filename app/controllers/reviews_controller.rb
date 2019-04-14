class ReviewsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
  end

  def new
    @item = Item.find(params[:item_id])
    @review = Review.new
    session[:oi_tracker] = params[:oi]
  end

  def create
    @item = Item.find(params[:item_id])
    @user = User.find(current_user.id)
    @review = @item.reviews.create(review_params)
    @review.user_id = @user.id
    if @review.save
      set_reveiwed_flag
      redirect_to user_reviews_path(current_user.id)
    else
      flash[:notice] = @review.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @item = Item.find(params[:item_id])
    @review = Review.find(params[:id])
  end

  def update
    @item = Item.find(params[:item_id])
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to user_reviews_path(current_user.id)
    else
      flash[:notice] = @review.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    review = Review.find(params[:id])
    review.destroy
    redirect_to user_reviews_path(current_user.id)
  end

private

  def review_params
    params.require(:review).permit(:title, :description, :rating)
  end
end
