require "rails_helper"

describe 'user sees avg item rating' do
  before :each do
    @user = User.create!(name: "Joe", email: "joe@gmail.com", password: "password", address: "123 Main", city: "Charleston", state: "SC", zip: "12345")
    @merchant = User.create!(name: "Jim", email: "jim@gmail.com", password: "password", address: "321 Main", city: "Charleston", state: "SC", zip: "12345", role: 1)
    @item1 = @merchant.items.create!(name: "item1", active: true, price: 2.5, description: "first item", inventory: 55, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    @item2 = @merchant.items.create!(name: "item2", active: true, price: 3.5, description: "second item", inventory: 65, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    @item3 = @merchant.items.create!(name: "item3", active: true, price: 4.5, description: "third item", inventory: 75, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    @review1 = @item1.reviews.create!(title: "review1", description: "bad", rating: 1, user_id: @user.id)
    @review2 = @item1.reviews.create!(title: "review2", description: "bleh", rating: 2, user_id: @user.id)
    @review3 = @item1.reviews.create!(title: "review3", description: "ok", rating: 3, user_id: @user.id)
    @review4 = @item1.reviews.create!(title: "review4", description: "better", rating: 4, user_id: @user.id)
    @review5 = @item1.reviews.create!(title: "review5", description: "best", rating: 5, user_id: @user.id)
  end

  it 'on the item index page' do
    visit items_path

    within "#item-#{@item1.id}" do
      expect(page).to have_content("Average rating: #{@item1.avg_rating}")
    end
  end

  it 'on the item show page' do
    visit item_path(@item1)

    within "#item-avg-rating" do
      expect(page).to have_content("Average rating: #{@item1.avg_rating}")
    end
  end
end
