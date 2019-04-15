require "rails_helper"

describe 'user clicks on update review' do
  it 'lets user update the review' do
    user = User.create!(name: "Joe", email: "joe@gmail.com", password: "password", address: "123 Main", city: "Charleston", state: "SC", zip: "12345")
    merchant = User.create!(name: "Jim", email: "jim@gmail.com", password: "password", address: "321 Main", city: "Charleston", state: "SC", zip: "12345", role: 1)
    item1 = merchant.items.create!(name: "item1", active: true, price: 2.5, description: "first item", inventory: 55, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    item2 = merchant.items.create!(name: "item2", active: true, price: 3.5, description: "second item", inventory: 65, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    item3 = merchant.items.create!(name: "item3", active: true, price: 4.5, description: "third item", inventory: 75, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    order = user.orders.create!(status: 2)
    oi1 = order.order_items.create!(item_id: item1.id, quantity: 4, price: 2.5, fulfilled: true)
    oi2 = order.order_items.create!(item_id: item2.id, quantity: 5, price: 3.5, fulfilled: true)
    oi3 = order.order_items.create!(item_id: item3.id, quantity: 6, price: 4.5, fulfilled: true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_order_path(order)

    within "#oitem-#{oi1.id}"do
      click_link "Leave a review"
    end

    expect(page).to have_content("New review")

    fill_in "Title", with: "Good product"
    fill_in "Description", with: "got a lot of good use out of it"
    fill_in "Rating", with: 4

    click_on "Create Review"

    review = Review.last
    expect(current_path).to eq(user_reviews_path(user))
    within "#info-#{review.id}" do
      click_on "Edit this review"
    end

    fill_in "Title", with: "Hated it"

    click_on "Update Review"

    expect(current_path).to eq(user_reviews_path(user))

    within "#info-#{review.id}" do
      expect(page).to have_content("Review title: Hated it")
    end
  end
end
