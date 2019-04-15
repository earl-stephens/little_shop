require "rails_helper"

describe 'on the item show page' do
  before :each do
    @user = User.create!(name: "Joe", email: "joe@gmail.com", password: "password", address: "123 Main", city: "Charleston", state: "SC", zip: "12345")
    @merchant = User.create!(name: "Jim", email: "jim@gmail.com", password: "password", address: "321 Main", city: "Charleston", state: "SC", zip: "12345", role: 1)
    @item1 = @merchant.items.create!(name: "item1", active: true, price: 2.5, description: "first item", inventory: 55, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    @item2 = @merchant.items.create!(name: "item2", active: true, price: 3.5, description: "second item", inventory: 65, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    @item3 = @merchant.items.create!(name: "item3", active: true, price: 4.5, description: "third item", inventory: 75, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    @review1 = @item1.reviews.create!(title: "review1", description: "bad", rating: 1, user_id: @user.id)
    @review2 = @item1.reviews.create!(title: "review2", description: "bleh", rating: 2, user_id: @user.id)
    @review3 = @item1.reviews.create!(title: "review3", description: "ok", rating: 3, user_id: @user.id)
    @review4 = @item2.reviews.create!(title: "review4", description: "better", rating: 4, user_id: @user.id)
    @review5 = @item2.reviews.create!(title: "review5", description: "best", rating: 5, user_id: @user.id)
  end

  it 'shows all reviews for the item' do
    visit item_path(@item1)

    within "#item-#{@review1.id}" do
      expect(page).to have_content("Review title: #{@review1.title}")
      expect(page).to have_content("Review author: #{@review1.author}")
      expect(page).to have_content("Review: #{@review1.description}")
      expect(page).to have_content("Review rating: #{@review1.rating}")
      expect(page).to have_content("Review written on: #{@review1.created_at.to_s(:long)}")
      expect(page).to have_content("Review updated on: #{@review1.updated_at.to_s(:long)}")
    end
    within "#item-#{@review2.id}" do
      expect(page).to have_content("Review title: #{@review2.title}")
      expect(page).to have_content("Review author: #{@review2.author}")
      expect(page).to have_content("Review: #{@review2.description}")
      expect(page).to have_content("Review rating: #{@review2.rating}")
      expect(page).to have_content("Review written on: #{@review2.created_at.to_s(:long)}")
      expect(page).to have_content("Review updated on: #{@review2.updated_at.to_s(:long)}")
    end
    within "#item-#{@review3.id}" do
      expect(page).to have_content("Review title: #{@review3.title}")
      expect(page).to have_content("Review author: #{@review3.author}")
      expect(page).to have_content("Review: #{@review3.description}")
      expect(page).to have_content("Review rating: #{@review3.rating}")
      expect(page).to have_content("Review written on: #{@review3.created_at.to_s(:long)}")
      expect(page).to have_content("Review updated on: #{@review3.updated_at.to_s(:long)}")
    end

    visit item_path(@item2)

    within "#item-#{@review4.id}" do
      expect(page).to have_content("Review title: #{@review4.title}")
      expect(page).to have_content("Review author: #{@review4.author}")
      expect(page).to have_content("Review: #{@review4.description}")
      expect(page).to have_content("Review rating: #{@review4.rating}")
      expect(page).to have_content("Review written on: #{@review4.created_at.to_s(:long)}")
      expect(page).to have_content("Review updated on: #{@review4.updated_at.to_s(:long)}")
    end
    within "#item-#{@review5.id}" do
      expect(page).to have_content("Review title: #{@review5.title}")
      expect(page).to have_content("Review author: #{@review5.author}")
      expect(page).to have_content("Review: #{@review5.description}")
      expect(page).to have_content("Review rating: #{@review5.rating}")
      expect(page).to have_content("Review written on: #{@review5.created_at.to_s(:long)}")
      expect(page).to have_content("Review updated on: #{@review5.updated_at.to_s(:long)}")
    end
  end
end
