class ReviewsController < ApplicationController

  def index
    @user = User.find_by(slug: params[:user_slug])
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
      redirect_to user_reviews_path(@user.slug)
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
      redirect_to user_reviews_path(current_user.slug)
    else
      flash[:notice] = @review.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    review = Review.find(params[:id])
    review.destroy
    OrderItem.find(session[:oi_tracker]).update(reviewed: false)
    session[:oi_tracker] = nil
    redirect_to user_reviews_path(current_user.slug)
  end

private

  def review_params
    params.require(:review).permit(:title, :description, :rating)
  end
end
